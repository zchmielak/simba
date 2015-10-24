/**
 * @file drivers/arm/uart_port.i
 * @version 1.0
 *
 * @section License
 * Copyright (C) 2014-2015, Erik Moqvist
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * This file is part of the Simba project.
 */

COUNTER_DEFINE("/drivers/uart/rx_channel_overflow", uart_rx_channel_overflow);
COUNTER_DEFINE("/drivers/uart/rx_errors", uart_rx_errors);

static int uart_port_start(struct uart_driver_t *drv_p)
{
    uint16_t cd = (F_CPU / 16 / drv_p->baudrate - 1);
    struct uart_device_t *dev_p = drv_p->dev_p;
    uint32_t mask;

    /* Configure the RX pin. */
    mask = dev_p->pio.rx.mask;
    dev_p->pio.rx.regs_p->PDR = mask;
    dev_p->pio.rx.regs_p->ODR = mask;
    dev_p->pio.rx.regs_p->IDR = mask;
    dev_p->pio.rx.regs_p->PUER = mask;
    dev_p->pio.rx.regs_p->ABSR &= ~mask;

    /* Configure the TX pin. */
    mask = dev_p->pio.tx.mask;
    dev_p->pio.tx.regs_p->PDR = mask;
    dev_p->pio.tx.regs_p->ODR = mask;
    dev_p->pio.tx.regs_p->IDR = mask;
    dev_p->pio.tx.regs_p->ABSR &= ~mask;

    /* Set baudrate. */
    dev_p->regs_p->US_BRGR = cd;

    /* Set mode and parity. */
    dev_p->regs_p->US_MR = (US_MR_USART_MODE_NORMAL
                            | US_MR_PAR_NO);
 
    /* Setup RX buffer of one byte in PDC. */
    /* dev_p->regs_p->US_PDC.RPR = (uint32_t)dev_p->rxbuf; */
    /* dev_p->regs_p->US_PDC.RCR = 1; */

    /* Enable TX and RX using the PDC end of transfer interrupts. */
    dev_p->regs_p->US_CR = US_CR_TXEN;

    /* Disable all interrupts. */
    dev_p->regs_p->US_IDR = (0xfffffffful);

    dev_p->regs_p->US_PDC.PTCR = (PERIPH_PTCR_TXTDIS);

    /* PMC */
    pmc_peripheral_clock_enable(dev_p->id);

    /* nvic */
    nvic_enable_interrupt(dev_p->id);

    dev_p->drv_p = drv_p;

    return (0);
}

static int uart_port_stop(struct uart_driver_t *drv_p)
{
    struct uart_device_t *dev_p = drv_p->dev_p;

    dev_p->regs_p->US_CR = 0;
    dev_p->regs_p->US_IDR = 0xfffffffful;
    dev_p->regs_p->US_PDC.PTCR = 0;

    dev_p->drv_p = NULL;

    return (0);
}

static ssize_t uart_port_write_cb(void *arg_p,
                                  const void *txbuf_p,
                                  size_t size)
{
    struct uart_driver_t *drv_p;
    struct uart_device_t *dev_p;

    drv_p = container_of(arg_p, struct uart_driver_t, chout);
    dev_p = drv_p->dev_p;

    sem_get(&drv_p->sem, NULL);

    sys_lock();

    /* Initiate transfer by writing to the PDC registers. */
    dev_p->regs_p->US_PDC.TPR = (uint32_t)txbuf_p;
    dev_p->regs_p->US_PDC.TCR = size;

    /* Enalbe the PDC. */
    dev_p->regs_p->US_PDC.PTCR = (PERIPH_PTCR_TXTEN);

    dev_p->regs_p->US_IER = (US_IER_ENDTX);

    drv_p->thrd_p = thrd_self();

    thrd_suspend_irq(NULL);

    /* Disable the PDC. */
    dev_p->regs_p->US_PDC.PTCR = (PERIPH_PTCR_TXTDIS);

    sys_unlock();

    sem_put(&drv_p->sem, 1);

    return (size);
}

static void isr(int index)
{
    struct uart_device_t *dev_p = &uart_device[index];
    struct uart_driver_t *drv_p = dev_p->drv_p;
    uint32_t csr, error;

    if (drv_p == NULL) {
        return;
    }

    /* Mask the expected signals. */
    csr = dev_p->regs_p->US_CSR;
    csr &= dev_p->regs_p->US_IMR;
    
    /* Handle tx complete signal. */
    if (csr & US_CSR_ENDTX) {
        dev_p->regs_p->US_IDR = (US_IDR_ENDTX);
        thrd_resume_irq(drv_p->thrd_p, 0);
    }

    if (csr & US_CSR_ENDRX) {
        error = (csr & (US_CSR_OVRE | US_CSR_FRAME | US_CSR_PARE));

        if (error == 0) {
            /* Write data to input queue. */
            if (queue_write_irq(&drv_p->chin, dev_p->rxbuf, 1) != 1) {
                COUNTER_INC(uart_rx_channel_overflow, 1);
            }
        } else {
            COUNTER_INC(uart_rx_errors, 1);
        }

        /* Reset counter to receive next byte. */
        dev_p->regs_p->US_PDC.RCR = 1;
    }
}

#define UART_ISR(vector, index)                 \
    ISR(vector) {                               \
        isr(index);                             \
    }                                           \

#if (UART_DEVICE_MAX >= 1)
UART_ISR(uart, 0)
#endif

#if (UART_DEVICE_MAX >= 2)
UART_ISR(usart0, 1)
#endif

#if (UART_DEVICE_MAX >= 3)
UART_ISR(usart1, 2)
#endif

#if (UART_DEVICE_MAX >= 4)
UART_ISR(usart2, 3)
#endif

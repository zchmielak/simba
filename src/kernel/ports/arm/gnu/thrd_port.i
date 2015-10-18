/**
 * @file arm/gnu/thrd_port.i
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

#define THRD_IDLE_STACK_MAX 512

static struct thrd_t main_thrd __attribute__ ((section (".main_stack")));

__attribute__((naked))
static void thrd_port_swap(struct thrd_t *in_p,
                           struct thrd_t *out_p)
{
    /* Store registers. lr is the return address. */
    asm volatile ("push {lr}");
    asm volatile ("push {r4-r11}");

    /* Save 'out_p' stack pointer. */
    asm volatile ("mov %0, sp" : "=r" (out_p->port.context_p));

    /* Restore 'in_p' stack pointer. */
    asm volatile ("mov sp, %0" : : "r" (in_p->port.context_p));

    /* Load registers. pop lr to pc and continue execution. */
    asm volatile ("pop {r4-r11}");
    asm volatile ("pop {pc}");
}

static void thrd_port_init_main(struct thrd_port_t *port)
{
}

__attribute__((naked))
static void thrd_port_entry(void)
{
    /* Enable interrupts. */
    asm volatile ("cpsie i");

    /* Call thread entry function with argument. */
    asm volatile ("mov r0, r10");
    asm volatile ("blx r9");

    /* Call termination function. */
    asm volatile ("blx %0" : : "r" (terminate));
}

static int thrd_port_spawn(struct thrd_t *thrd,
                           void *(*entry)(void *),
                           void *arg,
                           void *stack,
                           size_t stack_size)
{
    struct thrd_port_context_t *context_p;

    context_p = (stack + stack_size - sizeof(*context_p));
    context_p->r9 = (uint32_t)entry;
    context_p->r10 = (uint32_t)arg;
    context_p->pc = (uint32_t)thrd_port_entry;
    thrd->port.context_p = context_p;

    return (0);
}

static void thrd_port_idle_wait(struct thrd_t *thrd_p)
{
    asm volatile ("wfi");

    /* Add this thread to the ready list and reschedule. */
    sys_lock();
    thrd_p->state = THRD_STATE_READY;
    scheduler_ready_push(thrd_p);
    thrd_reschedule();
    sys_unlock();
}

static void thrd_port_suspend_timer_callback(void *arg_p)
{
    struct thrd_t *thrd = arg_p;

    /* Push thread on scheduler ready queue. */
    thrd->state = THRD_STATE_READY;
    scheduler_ready_push(thrd);
}

static void thrd_port_tick(void)
{
}

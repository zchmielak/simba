/**
 * @section License
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2014-2017, Erik Moqvist
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * This file is part of the Simba project.
 */

#include "simba.h"
#include "isotp_mock.h"

int mock_write_isotp_init(uint8_t *message_p,
                          size_t size,
                          int flags,
                          int res)
{
    harness_mock_write("isotp_init(message_p)",
                       message_p,
                       sizeof(*message_p));

    harness_mock_write("isotp_init(size)",
                       &size,
                       sizeof(size));

    harness_mock_write("isotp_init(flags)",
                       &flags,
                       sizeof(flags));

    harness_mock_write("isotp_init(): return (res)",
                       &res,
                       sizeof(res));

    return (0);
}

int __attribute__ ((weak)) STUB(isotp_init)(struct isotp_t *self_p,
                                            uint8_t *message_p,
                                            size_t size,
                                            int flags)
{
    int res;

    harness_mock_assert("isotp_init(message_p)",
                        message_p,
                        sizeof(*message_p));

    harness_mock_assert("isotp_init(size)",
                        &size,
                        sizeof(size));

    harness_mock_assert("isotp_init(flags)",
                        &flags,
                        sizeof(flags));

    harness_mock_read("isotp_init(): return (res)",
                      &res,
                      sizeof(res));

    return (res);
}

int mock_write_isotp_input(const uint8_t *buf_p,
                           size_t size,
                           ssize_t res)
{
    harness_mock_write("isotp_input(buf_p)",
                       buf_p,
                       sizeof(*buf_p));

    harness_mock_write("isotp_input(size)",
                       &size,
                       sizeof(size));

    harness_mock_write("isotp_input(): return (res)",
                       &res,
                       sizeof(res));

    return (0);
}

ssize_t __attribute__ ((weak)) STUB(isotp_input)(struct isotp_t *self_p,
                                                 const uint8_t *buf_p,
                                                 size_t size)
{
    ssize_t res;

    harness_mock_assert("isotp_input(buf_p)",
                        buf_p,
                        sizeof(*buf_p));

    harness_mock_assert("isotp_input(size)",
                        &size,
                        sizeof(size));

    harness_mock_read("isotp_input(): return (res)",
                      &res,
                      sizeof(res));

    return (res);
}

int mock_write_isotp_output(uint8_t *buf_p,
                            size_t *size_p,
                            ssize_t res)
{
    harness_mock_write("isotp_output(): return (buf_p)",
                       buf_p,
                       sizeof(*buf_p));

    harness_mock_write("isotp_output(): return (size_p)",
                       size_p,
                       sizeof(*size_p));

    harness_mock_write("isotp_output(): return (res)",
                       &res,
                       sizeof(res));

    return (0);
}

ssize_t __attribute__ ((weak)) STUB(isotp_output)(struct isotp_t *self_p,
                                                  uint8_t *buf_p,
                                                  size_t *size_p)
{
    ssize_t res;

    harness_mock_read("isotp_output(): return (buf_p)",
                      buf_p,
                      sizeof(*buf_p));

    harness_mock_read("isotp_output(): return (size_p)",
                      size_p,
                      sizeof(*size_p));

    harness_mock_read("isotp_output(): return (res)",
                      &res,
                      sizeof(res));

    return (res);
}

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

#ifndef __CIRCULAR_BUFFER_MOCK_H__
#define __CIRCULAR_BUFFER_MOCK_H__

#include "simba.h"

int mock_write_circular_buffer_init(void *buf_p,
                                    size_t size,
                                    int res);

int mock_write_circular_buffer_write(const void *buf_p,
                                     size_t size,
                                     ssize_t res);

int mock_write_circular_buffer_read(void *buf_p,
                                    size_t size,
                                    ssize_t res);

int mock_write_circular_buffer_used_size(ssize_t res);

int mock_write_circular_buffer_unused_size(ssize_t res);

int mock_write_circular_buffer_skip_front(size_t size,
                                          ssize_t res);

int mock_write_circular_buffer_reverse_skip_back(size_t size,
                                                 ssize_t res);

int mock_write_circular_buffer_array_one(void **buf_pp,
                                         size_t size,
                                         ssize_t res);

int mock_write_circular_buffer_array_two(void **buf_pp,
                                         size_t size,
                                         ssize_t res);

#endif

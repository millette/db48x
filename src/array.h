#ifndef ARRAY_H
#define ARRAY_H
// ****************************************************************************
//  array.h                                                       DB48X project
// ****************************************************************************
//
//   File Description:
//
//     Implementation of arrays (vectors, matrices and maybe tensors)
//
//
//
//
//
//
//
//
// ****************************************************************************
//   (C) 2023 Christophe de Dinechin <christophe@dinechin.org>
//   This software is licensed under the terms outlined in LICENSE.txt
// ****************************************************************************
//   This file is part of DB48X.
//
//   DB48X is free software: you can redistribute it and/or modify
//   it under the terms outlined in the LICENSE.txt file
//
//   DB48X is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// ****************************************************************************

#include "list.h"
#include "runtime.h"


GCP(array);

struct array : list
// ----------------------------------------------------------------------------
//   An array is a list with [ and ] as delimiters
// ----------------------------------------------------------------------------
{
    array(gcbytes bytes, size_t len, id type = ID_array)
        : list(bytes, len, type) {}

    static array_g map(algebraic_fn fn, array_r x)
    {
        return x->map(fn);
    }

    array_g map(algebraic_fn fn) const
    {
        return array_p(list::map(fn).Safe());
    }

    // Check if vector or matrix, and push all elements on stack
    bool is_vector(size_t *size) const;
    bool is_matrix(size_t *rows, size_t *columns) const;

public:
    OBJECT_DECL(array);
    PARSE_DECL(array);
    RENDER_DECL(array);
};


array_g operator-(array_r x);
array_g operator+(array_r x, array_r y);
array_g operator-(array_r x, array_r y);
array_g operator*(array_r x, array_r y);
array_g operator/(array_r x, array_r y);

#endif // ARRAY_H
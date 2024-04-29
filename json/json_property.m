## Serialize value and create JSON property
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_js] = json_property(p_ss, p_pk, p_pf, p_pv)
##                     non-interactive
##
## Usage 2: [r_js] = json_property([], p_pk, p_pf, p_pv)
##                     non-interactive
##                     load default JSON serialization settings (see json_settings.m)
##
## p_ss ... settings data structure, <struct_json_settings>
## p_pk ... property key, <str>
## p_pf ... property format identifier, <str>
##             scalar types: "bool", "str", "int", "uint", "float", "dbl"
##             array types:  "bool_arr", "str_arr", "int_arr", "uint_arr", "float_arr", "dbl_arr"
##             matrix types: "bool_mat", "str_mat", "int_mat", "uint_mat", "float_mat", "dbl_mat"
## p_pv ... property value, <any_octave_type>
## r_js ... return: JSON property, <str>
##
## Output format:
##
##  scalar value: "<key>" : <value>
##  array value:  "<key>" : [<value_1>, ..., <value_n>]
##  matrix value: "<key>" : [[<value_1_1>, ..., <value_n_1>], ... [<value_1_m>, ..., <value_n_m>]], column major
##
## see also: json_val_scalar.m, json_val_array.m, json_val_matrix.m, json_settings.m
##
## Copyright 2023 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
## License: MIT
## This file is part of the PhD thesis of Jakob Harden.
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
## documentation files (the “Software”), to deal in the Software without restriction, including without 
## limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
## the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
## 
## THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
## THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##
function [r_js] = json_property(p_ss, p_pk, p_pf, p_pv)
  
  ## check arguments
  if (nargin < 4)
    help json_property;
    error('Less arguments given!');
  endif
  
  ## set default values
  if isempty(p_ss)
    p_ss = json_settings();
  endif
  
  ## create JSON property
  switch (p_pf)
    case {'bool', 'str', 'int', 'uint', 'float', 'dbl'}
      r_js = ['"', p_pk, '" : ', json_val_scalar(p_ss, p_pf, p_pv)];
    case {'bool_arr', 'str_arr', 'int_arr', 'uint_arr', 'float_arr', 'dbl_arr'}
      r_js = ['"', p_pk, '" : ', json_val_array(p_ss, p_pf, p_pv)];
    case {'bool_mat', 'str_mat', 'int_mat', 'uint_mat', 'float_mat', 'dbl_mat'}
      r_js = ['"', p_pk, '" : ', json_val_matrix(p_ss, p_pf, p_pv)];
    otherwise
      error('Unknown value type enumerator: %s', p_pf);
  endswitch
  
endfunction

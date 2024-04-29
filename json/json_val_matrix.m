## Serialize matrix value
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ps] = json_val_matrix(p_ss, p_pf, p_pv)
##                     non-interactive
##
## Usage 2: [r_ps] = json_val_matrix([], p_pf, p_pv)
##                     non-interactive
##                     load default JSON serialization settings (see json_settings.m)
##
## p_ss ... settings data structure, <struct_json_settings>
## p_pf ... property format identifier, <str>
##            one out of: "bool_mat", "str_mat", "int_mat", "uint_mat", "float_mat", "dbl_mat"
## p_pv ... property value, <any_octave_type>
## r_ps ... return: property value string, <str>
##
## see also: json_settings.m
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
function [r_ps] = json_val_matrix(p_ss, p_pf, p_pv)
  
  ## check arguments
  if (nargin < 3)
    help json_val_matrix;
    error('Less arguments given!');
  endif
  
  ## set default values
  if isempty(p_ss)
    p_ss = json_settings();
  endif
  
  ## check empty value
  if isempty(p_pv)
    r_ps = '[]';
    return;
  endif
  
  ## matrix export limits, maximum number of columns
  imax = min([size(p_pv, 2), p_ss.ser.matrix_maxcols]);
  
  ## print info for large matrices
  if (imax < size(p_pv, 2))
    printf('INFO:\n  The number of exported matrix columns is reduced from %d to %d!\n  Export limit exceeded (ser.matrix_maxcols). See also: json_settings.m\n', size(p_pv, 2), imax);
  endif
  
  ## create JSON property string
  pf_arr = sprintf('%s_arr', p_pf(1:end-4));
  psl = cell(1, imax);
  for i = 1 : imax
    psl(i) = json_val_array(p_ss, pf_arr, p_pv(:, i));
  endfor
  r_ps = ['[', strjoin(psl, ', '), ']'];
  
endfunction

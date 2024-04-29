## Serialize array value
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ps] = json_val_array(p_ss, p_pf, p_pv)
##                   non-interactive
##
## Usage 2: [r_ps] = json_val_array([], p_pf, p_pv)
##                     non-interactive
##                     load default JSON serialization settings (see json_settings.m)
##
## p_ss ... settings data structure, <struct_json_settings>
## p_pf ... property format identifier, <str>
##            one out of: "bool_arr", "str_arr", "int_arr", "uint_arr", "float_arr", "dbl_arr"
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
function [r_ps] = json_val_array(p_ss, p_pf, p_pv)
  
  ## check arguments
  if (nargin < 3)
    help json_val_array;
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
  
  ## array export limits, size of array
  imax = min([numel(p_pv), p_ss.ser.array_maxelems]);
  
  ## print info for large arrays
  if (imax < numel(p_pv))
    printf('INFO:\n  The number of exported array elements is reduced from %d to %d!\n  Export limit exceeded (ser.array_maxelems). See also: json_settings.m\n', numel(p_pv), imax);
  endif
  
  ## create JSON property string
  pf_scal = p_pf(1:end-4);
  psl = cell(1, imax);
  for i = 1 : imax
    switch (p_pf)
      case 'str_arr'
        psl(i) = json_val_scalar(p_ss, pf_scal, p_pv{i});
      otherwise
        psl(i) = json_val_scalar(p_ss, pf_scal, p_pv(i));
    endswitch
  endfor
  r_ps = ['[', strjoin(psl, ', '), ']'];
  
endfunction

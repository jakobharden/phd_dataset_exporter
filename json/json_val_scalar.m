## Serialize scalar value
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ps] = json_val_scalar(p_ss, p_pf, p_pv)
##                     non-interactive
##
## Usage 2: [r_ps] = json_val_scalar([], p_pf, p_pv)
##                     non-interactive
##                     load default JSON serialization settings (see json_settings.m)
##
## p_ss ... settings data structure, <struct_json_settings>
## p_pf ... property format identifier, <str>
##            one out of: "bool", "str", "int", "uint", "float", "dbl"
## p_pv ... property value, <any_octave_type>
## r_ps ... return: property value string, <str>
##
## see also: json_settings.m, sprintf
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
function [r_ps] = json_val_scalar(p_ss, p_pf, p_pv)
  
  ## check arguments
  if (nargin < 3)
    help json_val_scalar;
    error('Less arguments given!');
  endif
  
  ## set default values
  if isempty(p_ss)
    p_ss = json_settings();
  endif
  
  ## check serialization of floating point numbers
  if (p_ss.ser.fixed_ndig)
    sng_fmt = ['%.', sprintf('%d', p_ss.ser.single_ndig), 'f'];
    dbl_fmt = ['%.', sprintf('%d', p_ss.ser.double_ndig), 'f'];
  else
    sng_fmt = '%f';
    dbl_fmt = '%f';
  endif
  
  ## create JSON property string
  if isempty(p_pv)
    r_ps = 'null';
  else
    switch (p_pf)
      case 'bool'
        if (p_pv)
          r_ps = 'true';
        else
          r_ps = 'false';
        endif
      case 'str'
        r_ps = sprintf('\"%s\"', p_pv);
      case 'int'
        r_ps = sprintf('%d', p_pv);
      case 'uint'
        r_ps = sprintf('%d', abs(p_pv));
      case 'float'
        r_ps = sprintf(sng_fmt, p_pv);
      case 'dbl'
        r_ps = sprintf(dbl_fmt, p_pv);
      otherwise
        printf('Value type enumerator unknown: %s. Replacing value with "null".\n', p_pf);
        r_ps = 'null';
    endswitch
  endif
  
endfunction

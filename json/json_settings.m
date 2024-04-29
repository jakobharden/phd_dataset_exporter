## Create data structure containing the JSON serialization settings
##
## FUNCTION SYNOPSIS:
##
## Usage: [r_ds] = json_settings()
##
## r_ds  ... return: JSON serialization settings, <struct>
##
## see also: json_struct_export.m
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
function [r_ds] = json_settings()
  
  ## init data structure
  r_ds.obj = 'struct_json_settings';
  r_ds.ver = uint16([1, 0]);
  
  #########################
  ## serialization settings
  #########################
  
  ## Use fixed number of digits to serialize floating point values
  ## If this setting is false, the settings "r_ds.ser.single_ndig" and "r_ds.ser.double_ndig" are ignored.
  ## see also: json_val_scalar.m
  r_ds.ser.fixed_ndig = true;
  
  ## Number of digits to be serialized, single precision floating point numbers
  ## number between 1 and 7
  ## see also: json_val_scalar.m
  r_ds.ser.single_ndig = 7;
  
  ## Number of digits to be serialized, double precision floating point numbers
  ## number between 1 and 16
  r_ds.ser.double_ndig = 16;
  
  ## maximum number of matrix columns to be serialized
  ## see also: json_val_matrix.m
  r_ds.ser.matrix_maxcols = 10;
  
  ## maximum number of array elements to be serialized
  ## see also: json_val_array.m
  r_ds.ser.array_maxelems = 20;
  
  ## indent step size, number of blanks
  r_ds.ser.indent_step = 2;
  
endfunction

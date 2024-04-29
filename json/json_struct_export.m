## Export data structure(s) to text file using the JSON structure format
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ec] = json_struct_export(p_ds, p_of, p_dn)
##                     non-interactive mode
##
## Usage 2: [r_ec] = json_struct_export(p_ds, p_of, [])
##          [r_ec] = json_struct_export(p_ds, p_of)
##                     non-interactive mode
##
## p_ds ... data structure, <struct>
## p_of ... output file path without extension, full qualified, <str>
## p_dn ... data structure name, optional, default = "structure", <str>
## r_ec ... return: error code, <bool>
##            true:  success
##            false: failure
##
## Note:
##   The following structure fields are considered:
##   - p_ds.obj ... object type descriptor, <str>
##   - p_ds.ver ... object version [major_version, minor_version], [<uint>]
##   - p_ds.algoname ... algorithm name, <str>
##   - p_ds.algover ... algorithm version [major_version, minor_version], [<uint>]
##   - p_ds.<f> ... if <f> is one of the following predefined atomic structure elements
##                         - ARE ... atomic reference element, <ARE/struct>
##                         - AAE ... atomic attribute element, <AAE/struct>
##                         - ADE ... atomic data element, <ADE/struct>
##
##  All other fields are ignored.
##
## see also: json_struct.m
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
function [r_ec] = json_struct_export(p_ds, p_of, p_dn)
  
  ## check arguments
  if (nargin < 2)
    help json_struct_export;
    error('Less arguments given!');
  endif
  if (nargin < 3)
    p_dn = 'structure';
  endif
  
  ## set default values
  p_ss = json_settings();
  
  ## convert data structure to JSON structure format
  [r_js, r_li, r_ai] = json_struct(p_ss, p_ds, p_dn);
  if isempty(r_js)
    r_ec = false;
    return;
  endif
  
  ## open JSON file
  fid = fopen([p_of, '.json'], 'w');
  printf('json_struct_export: opened file for writing, %s\n', p_of);
  if (fid < 0)
    r_ec = false;
    warning('json_struct_export: an error occured while opening file for writing!');
    return;
  else
    r_ec = true;
  endif
  
  ## write data to JSON file
  for i = 1 : numel(r_js)
    str_ind = repmat([' '], 1, p_ss.ser.indent_step * r_li(i));
    if (r_ai(i))
      str_arrsep = ',';
    else
      str_arrsep = '';
    endif
    fprintf(fid, '%s%s%s\n', str_ind, r_js{i}, str_arrsep);
  endfor
  
  ## close JSON file
  fclose(fid);
  printf('json_struct_export: closed file, %s\n', p_of);
  
endfunction

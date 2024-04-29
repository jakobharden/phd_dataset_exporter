## Serialize atomic data element (ADE)
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_js, r_li, r_ai] = json_struct_objdata(p_ss, p_ds)
##                                 non-interactive
##
## Usage 2: [r_js, r_li, r_ai] = json_struct_objdata([], p_ds)
##                                 non-interactive
##                                 load default JSON serialization settings (see json_settings.m)
##
## p_ss ... settings data structure, <struct_json_settings>
## p_ds ... atomic reference structure, <ARE/struct>
## r_js ... return: JSON object, {<str>}
## r_li ... return: level information, [<uint>]
## r_ai ... return: array information, [<bool>]
##
## see also: struct_objdata.m, json_property.m, json_settings.m
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
function [r_js, r_li, r_ai] = json_struct_objdata(p_ss, p_ds)
  
  ## check arguments
  if (nargin < 1)
    help json_struct_objdata;
    error('Less arguments given!');
  endif
  
  ## check type of data structure
  if (not(isfield(p_ds, 'obj')))
    warning('Data structure is not of type DATA!');
    r_js = {};
    return;
  else
    if (not(p_ds.obj == 'ADE'))
      warning('Data structure is not of type DATA!');
      r_js = {};
      return;
    endif
  endif
  
  ## set default values
  if isempty(p_ss)
    p_ss = json_settings();
  endif
  
  ## render data structure to JSON object
  r_js = cell(9, 1);
  r_js(1) = '{';
  r_js(2) = json_property(p_ss, 'obj', 'str', p_ds.obj);
  r_js(3) = json_property(p_ss, 'ver', 'uint_arr', p_ds.ver);
  r_js(4) = json_property(p_ss, 't', 'str', p_ds.t);
  r_js(5) = json_property(p_ss, 'd', 'str', p_ds.d);
  r_js(6) = json_property(p_ss, 'vt', 'str', p_ds.vt);
  switch (p_ds.u)
    case {'/', '#'}
      ## remove unit for scalar values
      r_js(7) = json_property(p_ss, 'u', 'str', '');
    otherwise
      r_js(7) = json_property(p_ss, 'u', 'str', p_ds.u);
  endswitch
  r_js(8) = json_property(p_ss, 'v', p_ds.vt, p_ds.v);
  r_js(9) = '}';
  
  ## return level information
  r_li = [0; 1; 1; 1; 1; 1; 1; 1; 0];
  
  ## return array information
  r_ai = [0; 1; 1; 1; 1; 1; 1; 0; 0];
  
endfunction

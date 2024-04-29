## Serialize data structure and data structure arrays using the JSON structure format
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_js, r_li, r_ai] = json_struct(p_ss, p_ds, p_dn)
##                                 non-interactive
##
## Usage 2: [r_js, r_li, r_ai] = json_struct(p_ss, p_ds, [])
##          [r_js, r_li, r_ai] = json_struct(p_ss, p_ds)
##                                 non-interactive
##                                 use default data structure name (p_dn = "ds")
##
## Usage 3: [r_js, r_li, r_ai] = json_struct([], p_ds, p_dn)
##                                 non-interactive
##                                 load default JSON serialization settings (see json_settings.m)
##
## p_ss ... settings data structure, optional, <struct_json_settings>
## p_ds ... data structure or data structure array, <struct> or [<struct>]
## p_dn ... data structure name, optional, default = "ds", <str>
## r_js ... return: JSON object string list, {<str>}
## r_li ... return: level information, [<uint>]
## r_ai ... return: array information, [<bool>]
##
## Note:
##   The following structure fields are considered:
##   - p_ds.obj ... object type descriptor, <str>
##   - p_ds.ver ... object version [major_version, minor_version], [<uint>]
##   - p_ds.algoname ... algorithm name, <str>
##   - p_ds.algover ... algorithm version [major_version, minor_version], [<uint>]
##   - p_ds.<f> ... if <f> is one of the following predefined atomic structure elements
##                    - ARE ... atomic reference element, <ARE/struct>
##                    - AAE ... atomic attribute element, <AAE/struct>
##                    - ADE ... atomic data element, <ADE/struct>
##
##  All other fields are ignored.
##
## see also: json_struct_objref.m, json_struct_objattrib, json_struct_objdata.m, json_settings.m
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
function [r_js, r_li, r_ai] = json_struct(p_ss, p_ds, p_dn)
  
  ## check arguments
  if (nargin < 2)
    help json_struct;
    error('Less arguments given!');
  endif
  if (nargin < 3)
    p_dn = [];
  endif
  if isempty(p_ds)
    printf('Data structure "%s" is empty! Maybe not present in this dataset.\n', p_dn);
    r_js = {};
    r_li = [];
    r_ai = [];
    return;
  endif
  
  ## set default values
  if isempty(p_ss)
    p_ss = json_settings();
  endif
  if isempty(p_dn)
    p_dn = 'ds';
  endif
  
  ## check whether data structure is an atomic element or not
  if isfield(p_ds, 'obj')
    switch (p_ds.obj)
      case {'ARE', 'AAE', 'ADE'}
        ## start JSON listing
        r_js = {'{'};
        r_li = [0];
        r_ai = [0];
        ## serialize atomic element(s)
        [js, li, ai] = hlp_atomic(p_ss, p_ds);
        ## add object key
        js(1) = ['"', p_dn, '" : ', js{1}];
        ## update return values
        r_js = [r_js; js];
        r_li = [r_li; li + 1];
        r_ai = [r_ai; ai];
        ## end JSON listing
        r_js = [r_js; '}'];
        r_li = [r_li; 0];
        r_ai = [r_ai; 0];
        ## done
        return;
    endswitch
  endif
  
  ## start JSON listing
  r_js = {'{'};
  r_li = [0];
  r_ai = [0];
  
  ## create JSON object list of single data structure or array of data structures
  if (numel(p_ds) == 1)
    ## scalar structure, 1 element
    [js, li, ai] = hlp_struct_single(p_ss, p_ds);
  else
    ## structure array, n elements
    [js, li, ai] = hlp_struct_array(p_ss, p_ds);
  endif
  
  ## add object key
  js(1) = ['"', p_dn, '" : ', js{1}];
  
  ## update return values
  r_js = [r_js; js];
  r_li = [r_li; li + 1];
  r_ai = [r_ai; ai];
  
  ## end JSON listing
  r_js = [r_js; '}'];
  r_li = [r_li; 0];
  r_ai = [r_ai; 0];
  
endfunction

function [r_js, r_li, r_ai] = hlp_struct_array(p_ss, p_ds)
  ## Create JSON object list of an array of data structures
  ##
  ## p_ss ... settings data structure, <struct_json_settings>
  ## p_ds ... data structures, [<struct>]
  ## r_js ... JSON object string listing, {<str>}
  ## r_li ... return: level information, [<uint>]
  ## r_ai ... return: array information, [<bool>]
  
  ## begin array
  r_js = {'['};
  r_li = [0];
  r_ai = [0];
  
  ## collect data from structures
  for i = 1 : numel(p_ds)
    [js, li, ai] = hlp_struct_single(p_ss, p_ds(i));
    ## add array separator
    ai(end) = 1;
    ## update return values
    r_js = [r_js; js];
    r_li = [r_li; li + 1];
    r_ai = [r_ai; ai];
  endfor
  
  ## remove last array separator
  r_ai(end) = 0;
  
  ## end array
  r_js = [r_js; ']'];
  r_li = [r_li; 0];
  r_ai = [r_ai; 0];
  
endfunction

function [r_js, r_li, r_ai] = hlp_struct_single(p_ss, p_ds)
  ## Create JSON object list of single data structure
  ##
  ## p_ss ... settings data structure, <struct_json_settings>
  ## p_ds ... data structure, <struct>
  ## r_js ... JSON object string listing, {<str>}
  ## r_li ... return: level information, [<uint>]
  ## r_ai ... return: array information, [<bool>]
  
  ## enlist field names
  fldlst = fieldnames(p_ds);
  
  ## begin JSON object
  r_js = {'{'};
  r_li = [0];
  r_ai = [0];
  
  ## collect data from structure fields
  for i = 1 : numel(fldlst)
    ## init results for current field
    js_i = {};
    li_i = [];
    ai_i = [];
    ## current field name
    fn_i = fldlst{i};
    ## current substructure or field
    ds_i = getfield(p_ds, fn_i);
    ## check for empty fields or structures
    if isempty(ds_i)
      continue;
    endif
    ## distinction between structure fields and substructures
    if isstruct(ds_i)
      ## handle structure
      ## check whether obj field exists or not
      if isfield(ds_i(1), 'obj')
        ## distinction between atomic elements and other substructures
        switch (ds_i(1).obj)
          case {'AAE', 'ARE', 'ADE'}
            [js_i, li_i, ai_i] = hlp_atomic(p_ss, ds_i);
            ## add object key
            js_i(1) = ['"', fn_i, '" : ', js_i{1}];
            ## add array separator
            ai_i(end) = 1;
          otherwise
            if (numel(ds_i) > 1)
              ## handle substructure array
              [js_i, li_i, ai_i] = hlp_struct_array(p_ss, ds_i);
              ## add object key
              js_i(1) = ['"', fn_i, '" : ', js_i{1}];
            else
              ## handle scalar substructure
              [js_i, li_i, ai_i] = hlp_struct_single(p_ss, ds_i);
              ## add object key
              js_i(1) = ['"', fn_i, '" : ', js_i{1}];
            endif
            ## add array separator
            ai_i(end) = 1;
        endswitch
      endif
    else
      ## handle recognized structure fields
      switch (fn_i)
        case 'obj'
          js_i = json_property(p_ss, fn_i, 'str', ds_i);
          li_i = [0];
          ai_i = [1];
        case 'ver'
          js_i = json_property(p_ss, fn_i, 'uint_arr', ds_i);
          li_i = [0];
          ai_i = [1];
        case 'algoname'
          js_i = json_property(p_ss, fn_i, 'str', ds_i);
          li_i = [0];
          ai_i = [1];
        case 'algover'
          js_i = json_property(p_ss, fn_i, 'uint_arr', ds_i);
          li_i = [0];
          ai_i = [1];
      endswitch
    endif
    ## update listing
    if not(isempty(js_i))
      r_js = [r_js; js_i];
      r_li = [r_li; li_i + 1];
      r_ai = [r_ai; ai_i];
    endif
  endfor
  
  ## remove last array separator
  r_ai(end) = 0;
  
  ## end JSON object
  r_js = [r_js; '}'];
  r_li = [r_li; 0];
  r_ai = [r_ai; 0];
  
endfunction

function [r_js, r_li, r_ai] = hlp_atomic(p_ss, p_ds)
  ## Create JSON object(s) of atomic element(s)
  ##
  ## p_ss ... settings data structure, <struct_json_settings>
  ## p_ds ... atomic structure element, <struct> or [<struct>]
  ## r_js ... JSON object string listing, {<str>}
  ## r_li ... return: level information, [<uint>]
  ## r_ai ... return: array information, [<bool>]
  
  if (numel(p_ds) == 1)
    ## scalar structure, 1 element
    [r_js, r_li, r_ai] = hlp_atomic_single(p_ss, p_ds);
  else
    ## structure array, n elements
    [r_js, r_li, r_ai] = hlp_atomic_array(p_ss, p_ds);
  endif
  
endfunction

function [r_js, r_li, r_ai] = hlp_atomic_array(p_ss, p_ds)
  ## Create JSON object of array of atomic elements
  ##
  ## p_ss ... settings data structure, <struct_json_settings>
  ## p_ds ... array of atomic structure elements, [<ARE/struct>] or [<AAE/struct>] or [<ADE/struct>]
  ## r_js ... JSON object string listing, {<str>}
  ## r_li ... return: level information, [<uint>]
  ## r_ai ... return: array information, [<bool>]
  
  ## begin array
  r_js = {'['};
  r_li = [0];
  r_ai = [0];
  
  ## collect data from structures
  arr_cnt = 0;
  for i = 1 : numel(p_ds)
    ## current element
    ds_i = p_ds(i);
    ## check cardinality of element
    if (numel(ds_i) > 1)
      ## recursive call of this function
      [js, li, ai] = hlp_atomic_array(p_ss, ds_i);
    else
      ## single element
      [js, li, ai] = hlp_atomic_single(p_ss, ds_i);
    endif
    if not(isempty(js))
      ## add array separator
      ai(end) = 1;
      ## update listing
      r_js = [r_js; js];
      r_li = [r_li; li + 1];
      r_ai = [r_ai; ai];
      arr_cnt = arr_cnt + 1;
    endif
  endfor
  
  ## remove last array separator
  if (arr_cnt > 0)
    r_ai(end) = 0;
  endif
  
  ## end array
  r_js = [r_js; ']'];
  r_li = [r_li; 0];
  r_ai = [r_ai; 0];
  
endfunction

function [r_js, r_li, r_ai] = hlp_atomic_single(p_ss, p_ds)
  ## Check type of atomic structure and return JSON object
  ##
  ## p_ss ... settings data structure, <struct_json_settings>
  ## p_ds ... atomic structure element, <ARE/struct> or <AAE/struct> or <ADE/struct>
  ## r_js ... JSON object, {<str>}
  ## r_li ... return: level information, [<uint>]
  ## r_ai ... return: array information, [<bool>]
  
  switch (p_ds.obj)
    case 'AAE'
      [r_js, r_li, r_ai] = json_struct_objattrib(p_ss, p_ds);
    case 'ARE'
      [r_js, r_li, r_ai] = json_struct_objref(p_ss, p_ds);
    case 'ADE'
      [r_js, r_li, r_ai] = json_struct_objdata(p_ss, p_ds);
    otherwise
      r_js = {};
      r_li = [];
      r_ai = [];
  endswitch
  
endfunction

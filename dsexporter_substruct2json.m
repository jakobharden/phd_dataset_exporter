## Export a dataset substructure to a file in JSON structure format
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ofp] = dsexporter_substruct2json(p_ss, p_odp, p_ifp, p_dsp)
##                      non-interactive mode
##
## Usage 2: [r_ofp] = dsexporter_substruct2json(p_ss, p_odp, p_ifp, [])
##          [r_ofp] = dsexporter_substruct2json(p_ss, p_odp, p_ifp)
##                      interactive mode
##                      show substructure path selection dialogue, GUI
##
## Usage 3: [r_ofp] = dsexporter_substruct2json(p_ss, p_odp, [], p_dsp)
##                      interactive mode
##                      show dataset file selection dialogue, GUI
##
## Usage 4: [r_ofp] = dsexporter_substruct2json(p_ss, [], p_ifp, p_dsp)
##                      non-interactive mode
##                      use fallback value for output directory path (./tmp)
##
## Usage 5: [r_ofp] = dsexporter_substruct2json([], p_odp, p_ifp, p_dsp)
##                      non-interactive mode
##                      load default export settings (see also: dsexporter_settings.m)
##
## p_ss  ... export settings data structure, optional, <struct_export_settings>
## p_odp ... output directory path, optional, default = "./tmp" <str>
## p_ifp ... dataset data structure or full qualified file path to dataset file, optional, <struct_dataset> or <str>
## p_dsp ... dataset structure path, optional, <str>
## r_ofp ... return: output file path(s), <str> or {<str>}
##
## see also: tool_gui_dsload.m, dsexporter_substruct.m, json_struct_export.m, json_settings.m
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
function [r_ofp] = dsexporter_substruct2json(p_ss, p_odp, p_ifp, p_dsp)
  
  ## check arguments
  if (nargin < 1)
    p_ss = [];
  endif
  if (nargin < 2)
    p_odp = [];
  endif
  if (nargin < 3)
    p_ifp = [];
  endif
  if (nargin < 4)
    p_dsp = [];
  endif
  
  ## load export settings
  if isempty(p_ss)
    p_ss = dsexporter_settings();
  endif
  
  ## load dataset
  ds = tool_gui_dsload(p_ifp);
  
  ## select śubstructure path
  spath = tool_gui_selsub(ds, p_ss.struct_paths_1, p_dsp);
  
  ## check output directory path
  if isempty(p_odp)
    p_odp = fullfile('.', 'tmp');
  endif
  
  ## dataset code, part of file name
  dscode = dsexporter_substruct(p_ss, ds, 'meta_set_code').v;
  
  ## extract selected dataset substructure
  dssub = dsexporter_substruct(p_ss, ds, spath);
  
  ## output file name
  if (p_ss.fn_append_tmcode)
    ofn = sprintf('%s_%s_%s', dscode, spath, strftime('%Y%m%d%H%M%S', localtime(time())));
  else
    ofn = sprintf('%s_%s', dscode, spath);
  endif
  
  ## output file path
  ofp = fullfile(p_odp, ofn);
  
  ## JSON object name
  json_obj_name = [dscode, '_', spath];
  
  ## export selected dataset substructure to JSON structure format
  errcode = json_struct_export(dssub, ofp, json_obj_name);
  
  ## check error code
  if (errcode)
    ## success
    r_ofp = ofp;
  else
    ## failure
    r_ofp = [];
  endif
  
endfunction

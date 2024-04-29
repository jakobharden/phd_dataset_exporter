## Export a dataset substructure to a variable
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ds] = dsexporter_substruct(p_ss, p_fp, p_sp)
##                     non-interactive mode
##
## Usage 2: [r_ds] = dsexporter_substruct(p_ss, p_fp, [])
##          [r_ds] = dsexporter_substruct(p_ss, p_fp)
##                     interactive mode
##                     show substructure path selection dialogue, GUI
##
## Usage 3: [r_ds] = dsexporter_substruct(p_ss, [], p_sp)
##                     interactive mode
##                     show dataset file selection dialogue, GUI
##
## Usage 4: [r_ds] = dsexporter_substruct([], p_fp, p_sp)
##                     non-interactive mode
##                     load default export settings (see also: dsexporter_settings.m)
##
## p_ss ... export settings data structure, optional, <struct_export_settings>
## p_fp ... dataset data structure or full qualified file path to dataset, optional, <struct_dataset> or <str>
## p_sp ... substructure path, optional, <str>
## r_ds ... return: selected substructure of dataset, <struct>
##
## see also: tool_gui_dsload.m, tool_gui_selsub.m
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
function [r_ds] = dsexporter_substruct(p_ss, p_fp, p_sp)
  
  ## check arguments
  if (nargin < 1)
    p_ss = [];
  endif
  if (nargin < 2)
    p_fp = [];
  endif
  if (nargin < 3)
    p_sp = [];
  endif
  
  ## load dataset
  ds = tool_gui_dsload(p_fp);
  
  ## load export settings
  if isempty(p_ss)
    p_ss = dsexporter_settings();
  endif
  
  ## select substructure path
  ## selection 2, often used substructure paths
  spath = tool_gui_selsub(ds, p_ss.struct_paths_2, p_sp);
  
  ## init return value
  r_ds = [];
  
  ## switch structure path
  switch (spath)
    case {'meta_ser'}
      r_ds = ds.meta_ser;
    case {'meta_ser_code', 'meta_ser.a01'}
      r_ds = ds.meta_ser.a01;
    case {'meta_set'}
      r_ds = ds.meta_set;
    case {'meta_set_code', 'meta_set.a01'}
      r_ds = ds.meta_set.a01;
    case {'loc'}
      r_ds = ds.loc;
    case {'lic'}
      r_ds = ds.lic;
    case {'aut'}
      r_ds = ds.aut;
    case {'dev'}
      r_ds = ds.dev;
    case {'mat'}
      r_ds = ds.mat;
    case {'mix'}
      if not(isempty(ds.mix))
        r_ds = ds.mix;
      else
        printf('INFO:\n  Mixture substructure is not available in this dataset!\n');
      endif
    case {'rec'}
      if not(isempty(ds.rec))
        r_ds = ds.rec;
      else
        printf('INFO:\n  Mixture recipe substructure is not available in this dataset!\n');
      endif
    case {'spm'}
      r_ds = ds.spm;
    case {'spm1_code', 'spm1.a01'}
      r_ds = ds.spm(1).a01;
   case {'spm2_code', 'spm2.a01'}
      if (numel(ds.spm) > 1)
        r_ds = ds.spm(2).a01;
      else
        ## return code of specimen I
        ## reference tests contain only one specimen used for compression- and shear wave measurements
        ## reference test series: ts3, ts5, ts6, ts7
        r_ds = ds.spm(1).a01;
        printf('INFO:\n  This seems to be a reference test on a single specimen! Returning code of specimen I instead.\n');
      endif
    case {'tst'}
      r_ds = ds.tst;
    case {'tst.fpd', 'tst.s01'}
      if not(isempty(ds.tst.s01))
        r_ds = ds.tst.s01;
      else
        printf('INFO:\n  Fresh paste density test structure is not available in this dataset!\n');
      endif
    case {'tst.fpd.den', 'tst.s01.d06'}
      if not(isempty(ds.tst.s01))
        r_ds = ds.tst.s01.d06;
      else
        printf('INFO:\n  Fresh paste density data (density) is not available in this dataset!\n');
      endif
    case {'tst.ssd1','tst.s02'}
      r_ds = ds.tst.s02;
    case {'tst.ssd1.den','tst.s02.d08'}
      r_ds = ds.tst.s02.d08;
    case {'tst.ssd2', 'tst.s03'}
      r_ds = ds.tst.s03;
    case {'tst.ssd2.den','tst.s03.d08'}
      r_ds = ds.tst.s03.d08;
    case {'tst.umd1', 'tst.s04'}
      r_ds = ds.tst.s04;
    case {'tst.umd1.dist', 'tst.s04.d04'}
      r_ds = ds.tst.s04.d04;
    case {'tst.umd2', 'tst.s05'}
      r_ds = ds.tst.s05;
    case {'tst.umd2.dist', 'tst.s05.d04'}
      r_ds = ds.tst.s05.d04;
    case {'tst.utt1', 'tst.s06'}
      r_ds = ds.tst.s06;
    case {'tst.utt1.i0', 'tst.s06.d09'}
      r_ds = ds.tst.s06.d09;
    case {'tst.utt1.t0', 'tst.s06.d02'}
      r_ds = ds.tst.s06.d02;
    case {'tst.utt1.mat', 'tst.s06.d11'}
      r_ds = ds.tst.s06.d11;
    case {'tst.utt1.ts', 'tst.s06.d12'}
      r_ds = ds.tst.s06.d12;
    case {'tst.utt1.ms', 'tst.s06.d13'}
      r_ds = ds.tst.s06.d13;
    case {'tst.utt1.pw', 'tst.s06.d06'}
      r_ds = ds.tst.s06.d06;
    case {'tst.utt1.sr', 'tst.s06.d07'}
      r_ds = ds.tst.s06.d07;
    case {'tst.utt2', 'tst.s07'}
      r_ds = ds.tst.s07;
    case {'tst.utt2.i0', 'tst.s07.d09'}
      r_ds = ds.tst.s07.d09;
    case {'tst.utt2.t0', 'tst.s07.d02'}
      r_ds = ds.tst.s07.d02;
    case {'tst.utt2.mat', 'tst.s07.d11'}
      r_ds = ds.tst.s07.d11;
    case {'tst.utt2.ts', 'tst.s07.d12'}
      r_ds = ds.tst.s07.d12;
    case {'tst.utt2.ms', 'tst.s07.d13'}
      r_ds = ds.tst.s07.d13;
    case {'tst.utt2.pw', 'tst.s07.d06'}
      r_ds = ds.tst.s07.d06;
    case {'tst.utt2.sr', 'tst.s07.d07'}
      r_ds = ds.tst.s07.d07;
    case {'tst.tem', 'tst.s08'}
      if not(isempty(ds.tst.s08))
        r_ds = ds.tst.s08;
      else
        printf('INFO:\n  Specimen temperature test structure is not available in this dataset!\n');
      endif
    case {'tst.tem.mat', 'tst.s08.d02'}
      if not(isempty(ds.tst.s08))
        r_ds = ds.tst.s08.d02;
      else
        printf('INFO:\n  Specimen temperature test data (maturity array) is not available in this dataset!\n');
      endif
    case {'tst.tem.t1', 'tst.s08.d03'}
      if not(isempty(ds.tst.s08))
        r_ds = ds.tst.s08.d03;
      else
        printf('INFO:\n  Specimen temperature test data (channel 1, T1) is not available in this dataset!\n');
      endif
    case {'tst.tem.t2', 'tst.s08.d04'}
      if not(isempty(ds.tst.s08))
        r_ds = ds.tst.s08.d04;
      else
        printf('INFO:\n  Specimen temperature test data (channel 2, T2) is not available in this dataset!\n');
      endif
    case {'tst.tem.t3', 'tst.s08.d05'}
      if not(isempty(ds.tst.s08))
        r_ds = ds.tst.s08.d05;
      else
        printf('INFO:\n  Specimen temperature test data (channel 3, T3) is not available in this dataset!\n');
      endif
    case {'tst.tem.t4', 'tst.s08.d06'}
      if not(isempty(ds.tst.s08))
        r_ds = ds.tst.s08.d06;
      else
        printf('INFO:\n  Specimen temperature test data (channel 4, T4) is not available in this dataset!\n');
      endif
    case {'tst.env', 'tst.s09'}
      r_ds = ds.tst.s09;
    case {'tst.env.tem', 'tst.s09.d02'}
      r_ds = ds.tst.s09.d02;
    otherwise
      help dsexporter_substruct;
      warning('Substructure element path "%s" not found in predefined paths!', spath);
  endswitch
  
endfunction

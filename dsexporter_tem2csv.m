## Export selected temperature data to CSV file (specimen temperature tests)
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ofp, r_ofh] = dsexporter_tem2csv(p_ss, p_odp, p_ifp, p_tcn, p_del)
##                             non-interactive mode
##
## Usage 2: [r_ofp, r_ofh] = dsexporter_tem2csv(p_ss, p_odp, p_ifp, p_tcn, [])
##          [r_ofp, r_ofh] = dsexporter_tem2csv(p_ss, p_odp, p_ifp, p_tcn)
##                             non-interactive mode
##                             use a comma as column delimiter (p_del = ",")
##
## Usage 3: [r_ofp, r_ofh] = dsexporter_tem2csv(p_ss, p_odp, p_ifp, [], p_del)
##          [r_ofp, r_ofh] = dsexporter_tem2csv(p_ss, p_odp, p_ifp)
##                             interactive mode
##                             show temperature channel selection dialogue, GUI
##
## Usage 4: [r_ofp, r_ofh] = dsexporter_tem2csv(p_ss, p_odp, [], p_tcn, p_del)
##                             interactive mode
##                             show dataset file selection dialogue, GUI
##
## Usage 5: [r_ofp, r_ofh] = dsexporter_tem2csv(p_ss, [], p_ifp, p_tcn, p_del)
##                             non-interactive mode
##                             use fallback value as output directory path (p_odp = "./tmp")
##
## Usage 6: [r_ofp, r_ofh] = dsexporter_tem2csv([], p_odp, p_ifp, p_tcn, p_del)
##                             non-interactive mode
##                             load default export settings (see also: dsexporter_settings.m)
##
## p_ss  ... export settings data structure, optional, <struct_export_settings>
## p_odp ... output directory path, optional, default = "./tmp", <str>
## p_ifp ... dataset data structure or full qualified file path to dataset file, optional, <struct_dataset> or <str>
## p_tcn ... temperature channel selection, optional, <uint>
##            1: channel T1, specimen, center
##            2: channel T2, specimen, next to sensor
##            3: channel T3, specimen, lateral
##            4: channel T4, outside, air
##            5: channel T1 to T3, specimen temperatures
##            6: channel T1 to T4, all temperatures
## p_del ... column delimiter, optional, default = ",", <str>
## r_ofd ... return: temperature data output file path, <str>
## r_ofh ... return: column head output file path, <str>
##
## Data output formats (*.csv):
##   p_tcn == 1: <signal_index><p_del><maturity><p_del><magn_t1>
##   p_tcn == 2: <signal_index><p_del><maturity><p_del><magn_t2>
##   p_tcn == 3: <signal_index><p_del><maturity><p_del><magn_t3>
##   p_tcn == 4: <signal_index><p_del><maturity><p_del><magn_t4>
##   p_tcn == 5: <signal_index><p_del><maturity><p_del><magn_t1><p_del><magn_t2><p_del><magn_t3>
##   p_tcn == 6: <signal_index><p_del><maturity><p_del><magn_t1><p_del><magn_t2><p_del><magn_t3><p_del><magn_t4>
##
## Column head output format (*.colheads):
##   +--------------------------------------------------------------------------------------+
##   | "Signal index" | "Maturity"  | Channel t1             | ... | Channel t4             | ... column names
##   +--------------------------------------------------------------------------------------+
##   |      "[#]"     | "[Seconds]" | "[°Celsius]"           | ... | "[°Celsius]"           | ... units, text
##   +--------------------------------------------------------------------------------------+
##   |      "[\#]"    | "[Seconds]" | "[${}^\circ$ Celsius]" | ... | "[${}^\circ$ Celsius]" | ... units, TeX code
##   +--------------------------------------------------------------------------------------+
##
## see also: dsexporter_settings.m, tool_gui_seltem.m, tool_gui_dsload.m, tool_get_maturity.m, dlmwrite
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
function [r_ofd, r_ofh] = dsexporter_tem2csv(p_ss, p_odp, p_ifp, p_tcn, p_del)
  
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
    p_tcn = [];
  endif
  if (nargin < 5)
    p_del = [];
  endif
  
  ## init return value
  r_ofd = [];
  r_ofh = [];
  
  ## load settings
  if isempty(p_ss)
    p_ss = dsexporter_settings();
  endif
  
  ## set default values
  if isempty(p_odp)
    p_odp = p_ss.dir_tmp_default;
  endif
  if isempty(p_del)
    p_del = p_ss.delim_csv_default;
  endif
  
  ## load dataset
  ds = tool_gui_dsload(p_ifp);
  
  ## check dataset
  if not(isfield(ds, 'tst'))
    error('Dataset does not contain any test data! Substructure "tst" not available.');
  endif
  if not(isfield(ds.tst, 's08'))
    printf('Dataset does not contain any specimen temperature tests! Substructure "tst.s08" not available.\n');
    return;
  endif
  if isempty(ds.tst.s08)
    printf('Dataset does not contain specimen temperature measurements. Substructure "tst.s08" is empty.\n');
    return;
  endif
  
  ## select temperature channel
  tcn = tool_gui_seltem(p_tcn);
  
  ## maturity time array
  mould_cn = 2; # specimen temperature teste were performed inside the mould of the shear wave (transversal) measurements
  ma = tool_get_maturity(ds, mould_cn, 'sec');
  
  ## signal index array
  ix = transpose(linspace(1, numel(ma), numel(ma)));
  
  ## temperature magnitude matrix
  tmat = [];
  switch (tcn)
    case 1
    ## export channel 1
    tmat = dsexporter_substruct(p_ss, ds, 'tst.tem.t1').v;
    cname = 't1';
  case 2
    ## export channel 2
    tmat = dsexporter_substruct(p_ss, ds, 'tst.tem.t2').v;
    cname = 't2';
  case 3
    ## export channel 3
    tmat = dsexporter_substruct(p_ss, ds, 'tst.tem.t3').v;
    cname = 't3';
  case 4
    ## export channel 4
    tmat = dsexporter_substruct(p_ss, ds, 'tst.tem.t4').v;
    cname = 't4';
  case 5
    ## export channel 1 to 3
    tmat = [...
      dsexporter_substruct(p_ss, ds, 'tst.tem.t1').v, ...
      dsexporter_substruct(p_ss, ds, 'tst.tem.t2').v, ...
      dsexporter_substruct(p_ss, ds, 'tst.tem.t3').v];
    cname = 't1-t3';
  case 6
    ## export channel 1 to 4
    tmat = [...
      dsexporter_substruct(p_ss, ds, 'tst.tem.t1').v, ...
      dsexporter_substruct(p_ss, ds, 'tst.tem.t2').v, ...
      dsexporter_substruct(p_ss, ds, 'tst.tem.t3').v, ...
      dsexporter_substruct(p_ss, ds, 'tst.tem.t4').v];
    cname = 't1-t4';
  otherwise
    help dsexporter_tem2csv;
    error('Temperature channel selection %d is not defined!', tcn);
  endswitch
  
  ## setup data table
  tab = [ix, ma, tmat];
  
  ## get dataset code
  dscode = dsexporter_substruct(p_ss, ds, 'meta_set_code').v;
  
  ## output file name
  if (p_ss.fn_append_tmcode)
    tmcode = strftime('%Y%m%d%H%M%S', localtime(time()));
    ofndata = sprintf('%s_tem_%s_%s.csv', dscode, cname, tmcode);
    ofnhead = sprintf('%s_tem_%s_%s.colheads', dscode, cname, tmcode);
  else
    ofndata = sprintf('%s_tem_%s.csv', dscode, cname);
    ofnhead = sprintf('%s_tem_%s.colheads', dscode, cname);
  endif
  
  ## setup output file paths
  r_ofd = fullfile(p_odp, ofndata);
  r_ofh = fullfile(p_odp, ofnhead);
  
  ## write data to CSV file
  dlmwrite(r_ofd, [ix, ma, tmat], 'delimiter', p_del);
  
  ## write column heads to CSV file
  hlp_write_columnhead_file(p_ss, r_ofh, tcn, p_del);
  
endfunction

function hlp_write_columnhead_file(p_ss, p_ofp, p_tcn, p_del)
  ## Write CSV file containing the column heads
  ##
  ## p_ss  ... settings data structure, <struct_dataexporter_settings>
  ## p_ofp ... output file path, <str>
  ## p_tcn ... temperature channel selection, optional, <uint>
  ## p_del ... column delimiter, <str>
  
  ## select specific settings
  sds = p_ss.colh.tem;
  
  ## switch temperature channel selection
  switch (p_tcn)
    case 1
    ## export channel 1
    colh = {...
      [sds.colidx, p_del, sds.colmat, p_del, sds.colt1];
      [sds.scalunit_ascii, p_del, sds.timeunit_ascii, p_del, sds.tempunit_ascii];
      [sds.scalunit_tex, p_del, sds.timeunit_tex, p_del, sds.tempunit_tex]};
  case 2
    ## export channel 2
    colh = {...
      [sds.colidx, p_del, sds.colmat, p_del, sds.colt2];
      [sds.scalunit_ascii, p_del, sds.timeunit_ascii, p_del, sds.tempunit_ascii];
      [sds.scalunit_tex, p_del, sds.timeunit_tex, p_del, sds.tempunit_tex]};
  case 3
    ## export channel 3
    colh = {...
      [sds.colidx, p_del, sds.colmat, p_del, sds.colt3];
      [sds.scalunit_ascii, p_del, sds.timeunit_ascii, p_del, sds.tempunit_ascii];
      [sds.scalunit_tex, p_del, sds.timeunit_tex, p_del, sds.tempunit_tex]};
  case 4
    ## export channel 4
    colh = {...
      [sds.colidx, p_del, sds.colmat, p_del, sds.colt4];
      [sds.scalunit_ascii, p_del, sds.timeunit_ascii, p_del, sds.tempunit_ascii];
      [sds.scalunit_tex, p_del, sds.timeunit_tex, p_del, sds.tempunit_tex]};
  case 5
    ## export channel 1 to 3
    colh = {...
      [sds.colidx, p_del, sds.colmat, p_del, sds.colt1, p_del, sds.colt2, p_del, sds.colt3];
      [sds.scalunit_ascii, p_del, sds.timeunit_ascii, p_del, sds.tempunit_ascii, p_del, sds.tempunit_ascii, p_del, sds.tempunit_ascii];
      [sds.scalunit_tex, p_del, sds.timeunit_tex, p_del, sds.tempunit_tex, p_del, sds.tempunit_tex, p_del, sds.tempunit_tex]};
  case 6
    ## export channel 1 to 4
    colh = {...
      [sds.colidx, p_del, sds.colmat, p_del, sds.colt1, p_del, sds.colt2, p_del, sds.colt3, p_del, sds.colt4];
      [sds.scalunit_ascii, p_del, sds.timeunit_ascii, p_del, sds.tempunit_ascii, p_del, sds.tempunit_ascii, p_del, sds.tempunit_ascii, p_del, sds.tempunit_ascii];
      [sds.scalunit_tex, p_del, sds.timeunit_tex, p_del, sds.tempunit_tex, p_del, sds.tempunit_tex, p_del, sds.tempunit_tex, p_del, sds.tempunit_tex]};
  endswitch
  
  ## write column heads to CSV file
  fid = fopen(p_ofp, 'w');
  for i = 1 : numel(colh)
    fprintf(fid, '%s\n', colh{i});
  endfor
  fclose(fid);
  
endfunction
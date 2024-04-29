## Export selected signal data to CSV file (compression- or shear wave signals)
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_ofd, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, p_si, p_i0, p_i1, p_del)
##                             non-interactive mode
##
## Usage 2: [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, p_si, p_i0, p_i1, [])
##          [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, p_si, p_i0, p_i1)
##                             non-interactive mode
##                             use comma as column delimiter (p_del = ",")
##
## Usage 3: [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, p_si, p_i0, [], p_del)
##                             non-interactive mode
##                             upper limit of the exported sample range is the last sample index (p_i1 = max. sample index)
##
## Usage 4: [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, p_si, [], p_i1, p_del)
##                             non-interactive mode
##                             lower limit of the exported sample range is the first sample index (p_i0 = 1)
##
## Usage 5: [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, [], p_i0, p_i1, p_del)
##                             interactive mode
##                             show signal selection dialogue, GUI
##
## Usage 6: [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, [], p_si, p_i0, p_i1, p_del)
##                             interactive mode
##                             show channel selection dialogue, GUI
##
## Usage 7: [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, [], p_cn, p_si, p_i0, p_i1, p_del)
##                             interactive mode
##                             show dataset file selection dialogue, GUI
##
## Usage 8: [r_ofp, r_ofh] = dsexporter_sig2csv(p_ss, [], p_ifp, p_cn, p_si, p_i0, p_i1, p_del)
##                             non-interactive mode
##                             use fallback value for output directory path (p_odp = "./tmp")
##
## Usage 9: [r_ofp, r_ofh] = dsexporter_sig2csv([], p_ifp, p_ifp, p_cn, p_si, p_i0, p_i1, p_del)
##                             non-interactive mode
##                             load default export settings (see also: dsexporter_settings.m)
##
## p_ss  ... export settings data structure, optional, <struct_export_settings>
## p_odp ... output directory path, optional, default = "./tmp" <str>
## p_ifp ... dataset data structure or full qualified file path to dataset file, optional, <struct_dataset> or <str>
## p_cn  ... channel number, optional, <uint>
##            1: channel 1, compression wave, logitudinal
##            2: channel 2, shear wave, transversal
##            3: both channels, compression- and shear wave
## p_si  ... signal index or signal index array, optional, <uint> or [<uint>]
## p_i0  ... sample range start index, optional, default = 1, <uint>
## p_i1  ... sample range end index, optional, default = max. sample index, <uint>
## p_del ... column delimiter, optional, default = "," (comma), <str>
## r_ofp ... return: signal data output file path(s), <str> or {<str>}
## r_ofh ... return: column head output file path(s), <str> or {<str>}
##
## Data output format (*.csv):
##   Rows: <sample_index><p_del><sample_time_signature><p_del><magnitude_1><p_del> ... <p_del><magnitude_n>
##   The number of columns containing the sample magnitudes is equal to the number selected signals (p_si).
##
## Column head output format (*.colheads):
##
##   +-----------------------------------------------------------------------------------------+
##   | "Channel name" | "N/A"                   | e.g. "C-wave (1)" | ... | e.g. "C-wave (1)"  | ... channel name
##   +-----------------------------------------------------------------------------------------+
##   | "Signal index" | "[#]"                   | e.g. "8"          | ... | e.g. "11"          | ... signal index
##   +-----------------------------------------------------------------------------------------+
##   | "Maturity"     | "[Seconds]"             | e.g. "2400"       | ... | e.g. "3300"        | ... maturity
##   +-----------------------------------------------------------------------------------------+
##   | "Sample index" | "Sample time signature" | e.g. "Signal # 8" | ... | e.g. "Signal # 11" | ... column heads, signal names
##   +-----------------------------------------------------------------------------------------+
##   |      "[#]"     | "[Seconds]"             | e.g. "[Volts]"    | ... | e.g. "[Volts]"     | ... units, ASCII format
##   +-----------------------------------------------------------------------------------------+
##   |      "[\#]"    | "[Seconds]"             | e.g. "[Volts]"    | ... | e.g. "[Volts]"     | ... units, LaTeX format
##   +-----------------------------------------------------------------------------------------+
##
## see also: tool_gui_dsload.m, tool_gui_selsig.m, tool_gui_selchn.m, dsexporter_substruct.m, tool_get_maturity.m, dlmwrite
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
function [r_ofd, r_ofh] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, p_si, p_i0, p_i1, p_del)
  
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
    p_cn = [];
  endif
  if (nargin < 5)
    p_si = [];
  endif
  if (nargin < 6)
    p_i0 = [];
  endif
  if (nargin < 7)
    p_i1 = [];
  endif
  if (nargin < 8)
    p_del = [];
  endif
  
  ## init return values
  r_ofd = {};
  r_ofh = {};
  
  ## load settings
  if isempty(p_ss)
    p_ss = dsexporter_settings();
  endif
  
  ## set default values
  if isempty(p_odp)
    p_ss.temp.odp = p_ss.dir_tmp_default;
  else
    p_ss.temp.odp = p_odp;
  endif
  if isempty(p_del)
    p_ss.temp.delim = p_ss.delim_csv_default;
  else
    p_ss.temp.delim = p_del;
  endif
  
  ## load dataset
  ds = tool_gui_dsload(p_ifp);
  
  ## select channel
  cn = tool_gui_selchn(p_cn);
  
  ## maturity
  ma_sec = tool_get_maturity(ds, cn, 'sec');
  ma_min = tool_get_maturity(ds, cn, 'min');
  
  ## select signal id(s)
  si = tool_gui_selsig(ma_min, p_si);
  
  ## select sample index range, lower and upper limit
  if isempty(p_i0)
    p_i0 = 1;
  endif
  isize1 = size(ds.tst.s06.d13.v, 1);
  isize2 = size(ds.tst.s07.d13.v, 1);
  isize3 = min([isize1, isize2]);
  if isempty(p_i1)
    switch (cn)
      case 1
        imax1 = isize1;
      case 2
        imax2 = isize2;
      case 3
        imax1 = isize3;
        imax2 = isize3;
      otherwise
        help dsexporter_sig2csv;
        error('Channel selection number %d is not defined!', cn);
    endswitch
  else
    imax1 = min([p_i1, isize3]);
    imax2 = min([p_i1, isize3]);
  endif
  
  ## dataset code, part of file name
  p_ss.temp.dscode = dsexporter_substruct(p_ss, ds, 'meta_set_code').v;
  
  ## time code, part of file name
  p_ss.temp.tmcode = strftime('%Y%m%d%H%M%S', localtime(time()));
  
  ## extract signal data, write CSV file(s)
  r_ofp = {};
  switch (cn)
    case 1
      ## channel 1, compression wave, longitudinal
      ## channel name, part of file name
      p_ss.temp.chname1 = 'c';
      p_ss.temp.chname2 = 'C-wave (1)';
      ## selected sample index range
      ix = transpose(p_i0 : imax1);
      ## signal maturity array, Seconds
      ma = ma_sec(si);
      ## sample time signature array
      ts = dsexporter_substruct(p_ss, ds, 'tst.utt1.ts').v(ix);
      ## signal magnitude matrix
      ms = dsexporter_substruct(p_ss, ds, 'tst.utt1.ms').v(ix, si);
      ## write signal data to CSV file
      r_ofd(1) = hlp_write_signaldata_file(p_ss, ix, ts, ms);
      ## write column heads to CSV file
      r_ofh(1) = hlp_write_columnhead_file(p_ss, si, ma);
    case 2
      ## channel 2, shear wave, transversal
      ## channel name, part of file name
      p_ss.temp.chname1 = 's';
      p_ss.temp.chname2 = 'S-wave (2)';
      ## selected sample index range
      ix = transpose(p_i0 : imax2);
      ## signal maturity array, Seconds
      ma = ma_sec(si);
      ## sample time signature array
      ts = dsexporter_substruct(p_ss, ds, 'tst.utt2.ts').v(ix);
      ## signal magnitude matrix
      ms = dsexporter_substruct(p_ss, ds, 'tst.utt2.ms').v(ix, si);
      ## write signal data to CSV file
      r_ofd(1) = hlp_write_signaldata_file(p_ss, ix, ts, ms);
      ## write column heads to CSV file
      r_ofh(1) = hlp_write_columnhead_file(p_ss, si, ma);
    case 3
      ## channel 1, compression wave, longitudinal
      ## channel name, part of file name
      p_ss.temp.chname1 = 'c';
      p_ss.temp.chname2 = 'C-wave (1)';
      ## selected sample index range
      ix = transpose(p_i0 : imax1);
      ## signal maturity array, Seconds
      ma = ma_sec(si);
      ## sample time signature array
      ts = dsexporter_substruct(p_ss, ds, 'tst.utt1.ts').v(ix);
      ## signal magnitude matrix
      ms = dsexporter_substruct(p_ss, ds, 'tst.utt1.ms').v(ix, si);
      ## write signal data to CSV file
      r_ofd(1) = hlp_write_signaldata_file(p_ss, ix, ts, ms);
      ## write column heads to CSV file
      r_ofh(1) = hlp_write_columnhead_file(p_ss, si, ma);
      ## channel 2, shear wave, transversal
      ## channel name, part of file name
      p_ss.temp.chname1 = 's';
      p_ss.temp.chname2 = 'S-wave (2)';
      ## selected sample index range
      ix = transpose(p_i0 : imax2);
      ## signal maturity array, Seconds
      ma = ma_sec(si);
      ## sample time signature array
      ts = dsexporter_substruct(p_ss, ds, 'tst.utt2.ts').v(ix);
      ## signal magnitude matrix
      ms = dsexporter_substruct(p_ss, ds, 'tst.utt2.ms').v(ix, si);
      ## write signal data to CSV file
      r_ofd(2) = hlp_write_signaldata_file(p_ss, ix, ts, ms);
      ## write column heads to CSV file
      r_ofh(2) = hlp_write_columnhead_file(p_ss, si, ma);
    otherwise
      help dsexporter_sig2csv;
      error('Channel selection number %d is not defined!', cn);
  endswitch
  
endfunction

function [r_ofp] = hlp_write_signaldata_file(p_ss, p_ix, p_ts, p_ms)
  ## Write CSV file containing the signal data
  ##
  ## p_ss  ... settings data structure, <struct_dsexporter_settings>
  ## p_ix  ... selected sample index range, [<uint>]
  ## p_ts  ... sample time signature array, [<dbl>]
  ## p_ms  ... sample magnitude matrix, [[<dbl>]]
  ## r_ofp ... return: output file path, <str>
  
  ## output file name
  if (p_ss.fn_append_tmcode)
    ofn = sprintf('%s_sig_%s_%s.csv', p_ss.temp.dscode, p_ss.temp.chname1, p_ss.temp.tmcode);
  else
    ofn = sprintf('%s_sig_%s.csv', p_ss.temp.dscode, p_ss.temp.chname1);
  endif
  
  ## output file path
  r_ofp = fullfile(p_ss.temp.odp, ofn);
  
  ## write signal data to CSV files
  dlmwrite(r_ofp, [p_ix, p_ts, p_ms], 'delimiter', p_ss.temp.delim);
  
endfunction

function [r_ofp] = hlp_write_columnhead_file(p_ss, p_si, p_ma)
  ## Write CSV file containing the column heads
  ##
  ## p_ss  ... settings data structure, <struct_dsexporter_settings>
  ## p_si  ... selected signal index array, [<uint>]
  ## p_ma  ... maturity array, Seconds, [<uint>]
  ## r_ofp ... return: output file path, <str>
  
  ## select specific settings
  sds = p_ss.colh.sig;
  
  ## init column head lines
  colh1 = [sds.chname, p_ss.temp.delim, sds.chnameunit];
  colh2 = [sds.sigidx, p_ss.temp.delim, sds.sigidxunit];
  colh3 = [sds.matname, p_ss.temp.delim, sds.matunit];
  colh4 = [sds.colidx, p_ss.temp.delim, sds.colts];
  colh5 = [sds.idxunit_ascii, p_ss.temp.delim, sds.tsunit_ascii];
  colh6 = [sds.idxunit_tex, p_ss.temp.delim, sds.tsunit_tex];
  ## append column heads of selected signals
  for si = p_si
    colh1 = [colh1, p_ss.temp.delim, '"', p_ss.temp.chname2, '"'];
  endfor
  for si = p_si
    colh2 = [colh2, p_ss.temp.delim, sprintf('"%d"', si)];
  endfor
  for mi = 1 : numel(p_ma)
    colh3 = [colh3, p_ss.temp.delim, sprintf('"%d"', p_ma(mi))];
  endfor
  for si = p_si
    colh4 = [colh4, p_ss.temp.delim, '"', sprintf('%s %d', sds.colmspfx, si), '"'];
  endfor
  for si = p_si
    colh5 = [colh5, p_ss.temp.delim, sds.msunit_ascii];
  endfor
  for si = p_si
    colh6 = [colh6, p_ss.temp.delim, sds.msunit_tex];
  endfor
  colh = {colh1; colh2; colh3; colh4; colh5; colh6};
  
  ## output file name
  if (p_ss.fn_append_tmcode)
    ofn = sprintf('%s_sig_%s_%s.colheads', p_ss.temp.dscode, p_ss.temp.chname1, p_ss.temp.tmcode);
  else
    ofn = sprintf('%s_sig_%s.colheads', p_ss.temp.dscode, p_ss.temp.chname1);
  endif
  
  ## output file path
  r_ofp = fullfile(p_ss.temp.odp, ofn);
  
  ## write column heads to CSV file
  fid = fopen(r_ofp, 'w');
  for i = 1 : numel(colh)
    fprintf(fid, '%s\n', colh{i});
  endfor
  fclose(fid);
  
endfunction

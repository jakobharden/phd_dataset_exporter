## Script to reproduce all export examples
##
## FUNCTION SYNOPSIS:
##
## Usage: dsexporter_examples()
##
## see also: dsexporter_sig2csv.m, dsexporter_tem2csv.m, dsexporter_substruct2tex.m, dsexporter_substruct2json.m
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
function dsexporter_examples()
  
  ## initialize program
  init();
  
  ## input file, dataset (*.oct)
  ## the dataset used in this example is available at the following URL: https://doi.org/10.3217/bhs4g-m3z76
  ##
  ## 1) download the record content (archive: ts1_datasets.tar.xz)
  ## 2) decompress the archive file to a directory of your choice: "</dataset/dir/path>"
  ## 3) adjust the input file path variable below (ifp) to the choosen directory: "</dataset/dir/path>"
  ifp = '/mnt/data/0_test_series/ts1_cem1_paste/oct/ts1_wc040_d50_6.oct';
  
  ## load dataset
  ds = tool_gui_dsload(ifp);
  
  ## LaTeX export
  example_latex(ds);
  
  ## TeX export
  example_tex(ds);
  
  ## JSON export
  example_json(ds);
  
  ## signal data export
  example_sigdata_csv(ds);
  
  ## specimen temperature data export
  example_temdata_csv(ds);

endfunction

function example_latex(p_ds)
  ## Reproduce LaTeX export example
  ##
  ## p_ds ... dataset data structure, <struct_dataset>
  
  ## load export settings
  ss = dsexporter_settings();
  ## do not append time code to filename
  ss.fn_append_tmcode = false;
  
  ## output directory path (local directory: "./tmp/latex")
  odp = fullfile('.', 'examples', 'latex');
  
  ## export test series metadata (TeX file)
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'meta_ser');
  
  ## export dataset metadata (TeX file)
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'meta_set');
  
  ## export environment temperature test (TeX file)
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'tst.env');
  
  ## export signal data (CSV file)
  scn = 3; # export compression- and shear wave measurement data
  sid = 288; # export last signal (maturity = 24 hours)
  i0 = 1001; # start sample index
  i1 = 1500; # end sample index
  coldel = ' ; '; # column delimiter
  ofp = dsexporter_sig2csv(ss, odp, p_ds, scn, sid, i0, i1, coldel);
  
  ## export specimen temperature measurement data (CSV file)
  tcn = 6; # export all channels (channel selection No. 6)
  ofp = dsexporter_tem2csv(ss, odp, p_ds, tcn, coldel);
  
endfunction

function example_tex(p_ds)
  ## Reproduce TeX code export example
  ##
  ## p_ds ... dataset data structure, <struct_dataset>
  
  ## load export settings
  ss = dsexporter_settings();
  ## append time code to filename
  ss.fn_append_tmcode = true;
  
  ## output directory path (local directory: "./examples/csv")
  odp = fullfile('.', 'examples', 'tex');
  
  ## export test series metadata
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'meta_ser');
  
  ## export dataset metadata
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'meta_set');
  
  ## export fresh paste density test (FPD)
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'tst.fpd');
  
  ## export ultrasonic measurement distance test, specimen I (UMD)
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'tst.umd1');
  
  ## export solid sample density test, specimen I (SSD)
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'tst.ssd1');
  
  ## export environment temperature test, specimen I (SSD)
  ofp = dsexporter_substruct2tex(ss, odp, p_ds, 'tst.env');
  
endfunction

function example_json(p_ds)
  ## Reproduce TeX code export example
  ##
  ## p_ds ... dataset data structure, <struct_dataset>
  
  ## load export settings
  ss = dsexporter_settings();
  ## append time code to filename
  ss.fn_append_tmcode = true;
  
  ## output directory path (local directory: "./examples/csv")
  odp = fullfile('.', 'examples', 'json');
  
  ## export test series metadata
  ofp = dsexporter_substruct2json(ss, odp, p_ds, 'meta_ser');
  
  ## export dataset metadata
  ofp = dsexporter_substruct2json(ss, odp, p_ds, 'meta_set');
  
  ## export fresh paste density test (FPD)
  ofp = dsexporter_substruct2json(ss, odp, p_ds, 'tst.fpd');
  
  ## export ultrasonic measurement distance test, specimen I (UMD)
  ofp = dsexporter_substruct2json(ss, odp, p_ds, 'tst.umd1');
  
  ## export solid sample density test, specimen I (SSD)
  ofp = dsexporter_substruct2json(ss, odp, p_ds, 'tst.ssd1');
  
  ## export environment temperature test, specimen I (SSD)
  ofp = dsexporter_substruct2json(ss, odp, p_ds, 'tst.env');
  
endfunction

function example_sigdata_csv(p_ds)
  ## Reproduce signal data export example
  ##
  ## p_ds ... dataset data structure, <struct_dataset>
  
  ## load export settings
  ss = dsexporter_settings();
  ## append time code to filename
  ss.fn_append_tmcode = true;
  
  ## output directory path (local directory: "./examples/csv")
  odp = fullfile('.', 'examples', 'csv');
  
  ## define column delimiter
  coldel = ','; # column delimiter
  
  ## export signal data, last signal
  scn = 3; # export compression- and shear wave measurement data
  sid = 288; # export last signal (maturity = 24 hours)
  i0 = 1001; # start sample index
  i1 = 1500; # end sample index
  ofp = dsexporter_sig2csv(ss, odp, p_ds, scn, sid, i0, i1, coldel);
  
  ## export signal data, subsequent signals
  scn = 3; # export compression- and shear wave measurement data
  sid = 20 : 25; # export all signals with a signal id between 20 and 25
  i0 = 1001; # start sample index
  i1 = 3000; # end sample index
  ofp = dsexporter_sig2csv(ss, odp, p_ds, scn, sid, i0, i1, coldel);
  
  ## export signal data, selected signals
  scn = 3; # export compression- and shear wave measurement data
  sid = [5, 10, 20, 50]; # export signals with signal id 5, 10, 20 and 50
  i0 = 1001; # start sample index
  i1 = 3000; # end sample index
  ofp = dsexporter_sig2csv(ss, odp, p_ds, scn, sid, i0, i1, coldel);
  
endfunction

function example_temdata_csv(p_ds)
  ## Reproduce specimen temperature data export example
  ##
  ## p_ds ... dataset data structure, <struct_dataset>
  
  ## load export settings
  ss = dsexporter_settings();
  ## append time code to filename
  ss.fn_append_tmcode = true;
  
  ## output directory path (local directory: "./examples/csv")
  odp = fullfile('.', 'examples', 'csv');
  
  ## define column delimiter
  coldel = ','; # column delimiter
  
  ## export specimen temperature measurement data
  tcn = 1; # export center temperature only
  ofp = dsexporter_tem2csv(ss, odp, p_ds, tcn, coldel);
  
  ## export specimen temperature measurement data
  tcn = 2; # export temperature next to sensor only
  ofp = dsexporter_tem2csv(ss, odp, p_ds, tcn, coldel);
  
  ## export specimen temperature measurement data
  tcn = 3; # export lateral temperature only
  ofp = dsexporter_tem2csv(ss, odp, p_ds, tcn, coldel);
  
  ## export specimen temperature measurement data
  tcn = 4; # export abient temperature only
  ofp = dsexporter_tem2csv(ss, odp, p_ds, tcn, coldel);
  
  ## export specimen temperature measurement data
  tcn = 5; # export all specimen temperature channels (channel selection No. 5)
  ofp = dsexporter_tem2csv(ss, odp, p_ds, tcn, coldel);
  
  ## export specimen temperature measurement data
  tcn = 6; # export all channels (channel selection No. 6)
  ofp = dsexporter_tem2csv(ss, odp, p_ds, tcn, coldel);
  
endfunction

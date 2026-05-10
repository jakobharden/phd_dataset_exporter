## Convert data set files from GNU Octave binary format to the Matlab file format (version 6)
##
## FUNCTION SYNOPSIS:
##
## Usage: dsexporter_convert_to_matlab(p_ip, p_op)
##
## p_ip ... input path, path to one data set or to a directory containing many data set files, <str>
## p_op ... output path, path to the HDF5 file output directory, optional, default = './tmp/matlabv6', <str>
##
## see also: 
##
## Copyright 2025 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
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
function dsexporter_convert_to_matlab(p_ip, p_op = [])
  
  ## check input file/directory
  exst = exist(p_ip);
  switch (exst)
    case 3
      ## file
      flst = dir(p_ip);
    case 7
      ## directory
      flst = dir(fullfile(p_ip, filesep, '*.oct'));
  otherwise
    ## does not exist
    error('Input file or directory "%s" does not exist!', p_ip);
  endswitch
  
  ## check ouput directory
  if (isempty(p_op))
    p_op = './tmp/matlabv6';
  endif
  exst = exist(p_op, 'dir');
  if (exst != 7)
    mkdir(p_op);
    exst = exist(p_op, 'dir');
    if (exst != 7)
      error('Cannot create Matlab file output directory "%s"!', p_op);
      mkdir(p_op);
    endif
  endif
  
  ## loop over file list
  for k = 1 : numel(flst)
    d = flst(k);
    dataset = load('-binary', fullfile(d.folder, filesep, d.name), 'dataset').dataset;
    ofn = strrep(d.name, '.oct', '.mat');
    ofp = fullfile(p_op, filesep, ofn);
    save('-mat-binary', ofp, 'dataset');
  endfor

endfunction

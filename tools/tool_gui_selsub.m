## Select substructure of dataset and return the structure path, GUI
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_sp] = tool_gui_selsub(p_ds, p_sl, p_sp)
##                     non-interactive mode
##
## Usage 2: [r_sp] = tool_gui_selsub(p_ds, p_sl, [])
##          [r_sp] = tool_gui_selsub(p_ds, p_sl)
##                     interactive mode
##                     show substructure selection dialogue, GUI
##
## Usage 3: [r_sp] = tool_gui_selsub([], p_sl, p_sp)
##                     non-interactive mode
##                     do not check the availability of substructures
##
## p_sp ... dataset data structure, <struct_dataset>
## p_sl ... structure path selection list, {{<str>}}
## p_sp ... substructure path, optional, <str>
## r_ds ... return: selected substructure path, <str>
##
## Note: The structure path selection list (p_sl) is a 2D cell array of strings. The first element of each row is the substructure path.
##       The second element is a descriptive display name of the substructure. Format: {<path>, <name>}
##       The lists of recognized substructure paths are defined in function file "dsexporter_settings.m".
##
## see also: listdlg
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
function [r_sp] = tool_gui_selsub(p_ds, p_sl, p_sp)
  
  ## check arguments
  if (nargin < 2)
    help tool_gui_selsub;
    error('Less arguments given!');
  endif
  if (nargin < 3)
    p_sp = [];
  endif
  
  ## check whether substructures are available in dataset or not
  if not(isempty(p_ds))
    ## init checklist, index array
    chklst = [];
    ## iterate over selection list
    for i = 1 : size(p_sl, 1)
      ## get path element array
      chkarr = p_sl(i, 3){1,1};
      ## check whether substructure exists and is not empty
      if (numel(chkarr) == 1)
        ## check first level of structure hierarchy
        if isfield(p_ds, chkarr{1})
          subds = getfield(p_ds, chkarr{1});
          if isempty(subds)
            chklst = [chklst, i];
          endif
        endif
      else
        ## check first level of structure hierarchy
        if isfield(p_ds, chkarr{1})
          subds = getfield(p_ds, chkarr{1});
          if not(isempty(subds))
            ## check second level of structure hierarchy
            if isfield(subds, chkarr{2})
              subds = getfield(subds, chkarr{2});
              if isempty(subds)
                chklst = [chklst, i];
              endif
            endif
          endif
        endif
      endif
    endfor
    ## remove list entries that point to non-existing or empty fields
    p_sl(chklst, :) = [];
  endif
  
  ## show selection dialogue
  if isempty(p_sp)
    [sel, ok] = listdlg(...
      "Name", "Select substructure", ...
      "PromptString", "Select dataset substructure", ...
      "ListSize", [480, 360], ...
      "ListString", p_sl(:, 2), ...
      "SelectionMode", "single");
    if (ok == 1)
      r_sp = p_sl(sel, 1){1,1};
    else
      error('Cancel button pressed! Exit.');
    endif
  else
    r_sp = p_sp;
  endif
  
endfunction

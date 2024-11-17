# Dataset Exporter, version 1.0

The **Dataset Exporter** is a script collection that allows exporting data from datasets made from measurement data of ultrasonic pulse transmission tests. The main features cover the export of substructures to variables and the serialization to the CSV format, the JSON structure format and TeX code.

[!INFO]
The entire content of this script collection was conceived, implemented and tested by Jakob Harden using the scientific numerical programming language of GNU Octave 6.2.0.

## Table of contents

- Licence
- Prerequisites
- Directory and file structure
- Installation instructions
- Usage instructions
- Help and Documentation
- Related data sources
- Related software
- Revision and release history


## Licence

All files published under the **DOI 10.3217/d3p6m-w7d64** are licenced under the [MIT licence](https://opensource.org/license/mit/).

	Copyright 2023 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
	License: MIT
	This file is part of the PhD thesis of Jakob Harden.
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
	documentation files (the “Software”), to deal in the Software without restriction, including without
	limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
	the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
	
	THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
	THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Prerequisites

To be able to use the scripts, GNU Octave 6.2.0 (or a higher version) need to be installed.
GNU Octave is available via the package management system on many Linux distributions. Windows users have to download the Windows version of GNU Octave and to install the software manually.

[GNU Octave download](https://octave.org/download)


## Directory and file structure

All scripts files (*.m) are plain text files written in the scientific programming language of GNU Octave 6.2.0.

```   
   dsexporter/   
   ├── dsexporter_examples.m   
   ├── dsexporter_settings.m   
   ├── dsexporter_sig2csv.m   
   ├── dsexporter_sig2snd.m   
   ├── dsexporter_substruct2json.m   
   ├── dsexporter_substruct2tex.m   
   ├── dsexporter_substruct.m   
   ├── dsexporter_tem2csv.m   
   ├── examples   
   │   ├── csv   
   │   ├── json   
   │   ├── latex   
   │   └── tex   
   ├── init.m   
   ├── json   
   │   ├── json_property.m   
   │   ├── json_settings.m   
   │   ├── json_struct_export.m   
   │   ├── json_struct.m   
   │   ├── json_struct_objattrib.m   
   │   ├── json_struct_objdata.m   
   │   ├── json_struct_objref.m   
   │   ├── json_val_array.m   
   │   ├── json_val_matrix.m   
   │   └── json_val_scalar.m   
   ├── README.html   
   ├── README.md   
   ├── struct   
   │   ├── struct_objattrib.m   
   │   ├── struct_objdata.m   
   │   └── struct_objref.m   
   ├── tex   
   │   ├── tex_def_csvarray.m   
   │   ├── tex_def_dotarray.m   
   │   ├── tex_def_scalar.m   
   │   ├── tex_def_tabarray.m   
   │   ├── tex_def_tabmatrix.m   
   │   ├── tex_serialize.m   
   │   ├── tex_settings.m   
   │   ├── tex_struct_export.m   
   │   ├── tex_struct.m   
   │   ├── tex_struct_objattrib.m   
   │   ├── tex_struct_objdata.m   
   │   └── tex_struct_objref.m   
   ├── tmp   
   └── tools   
       ├── tool_get_maturity.m   
       ├── tool_gui_dsload.m   
       ├── tool_gui_selchn.m   
       ├── tool_gui_selsig.m   
       ├── tool_gui_selsub.m   
       └── tool_gui_seltem.m   
```

- init.m ... function file, Initialize program: Dataset Exporter, version 1.0
- dsexporter\_examples.m ... function file, Script to reproduce all export examples
- dsexporter\_settings.m ... function file, Create data structure containing the dataset export settings
- dsexporter\_sig2csv.m ... function file, Export selected signal data to CSV file (compression- or shear wave signals)
- dsexporter\_sig2snd.m ... function file, Export selected signal data to sound file (compression- or shear wave signals)
- dsexporter\_tem2csv.m ... function file, Export selected temperature data to CSV file (specimen temperature tests)
- dsexporter\_substruct.m ... function file, Export a dataset substructure to a variable
- dsexporter\_substruct2json.m ... function file, Export a dataset substructure to a file in JSON structure format
- dsexporter\_substruct2tex.m ... function file, Export a dataset substructure to a TeX code file
- README.html ... HTML version of this file
- README.md ... this file
- **examples** ... directory, various examples for exported data (CSV, JSON, LaTeX, TeX)
  - **examples/csv** ... subdirectory, examples for CSV exports created with function file *dsexporter\_examples.m*
  - **examples/snd** ... subdirectory, examples for sound file exports created with function file *dsexporter\_examples.m*
  - **examples/json** ... subdirectory, examples for JSON exports created with function file *dsexporter\_examples.m*
  - **examples/latex** ... subdirectory, examples for LaTeX exports created with function file *dsexporter\_examples.m*
  - examples/latex/example.bib, TeX bibliography, bibliography file, minimal working LaTeX export example
  - examples/latex/example.pdf, Portable Document Format, compiled LaTeX document, minimal working LaTeX export example
  - examples/latex/example.tex, TeX code, main LaTeX document, minimal working LaTeX export example
  - examples/latex/oct2texdefs.tex, TeX code, data import functions, minimal working LaTeX export example
  - examples/latex/README.html, HTML format, HTML version of README.md
  - examples/latex/README.md, markdown format, brief introduction to the minimal working LaTeX export example
  - **examples/tex** ... subdirectory, examples for TeX code exports created with function file *dsexporter\_examples.m*
- **json** ... directory, subsidiary functions used to serialize data structures to JSON structure format
  - json/json\_property.m ... function file, Serialize value and create JSON property
  - json/json\_settings.m ... function file, Create data structure containing the JSON serialization settings
  - json/json\_struct\_export.m ... function file, Export data structure(s) to text file using the JSON structure format
  - json/json\_struct.m ... function file, Serialize data structure and data structure arrays using the JSON structure format
  - json/json\_struct\_objattrib.m ... function file, Serialize atomic attribute element (AAE)
  - json/json\_struct\_objdata.m ... function file, Serialize atomic data element (ADE)
  - json/json\_struct\_objref.m ... function file, Serialize atomic reference element (ARE)
  - json/json\_val\_array.m ... function file, Serialize array value
  - json/json\_val\_matrix.m ... function file, Serialize matrix value
  - json/json\_val\_scalar.m ... function file, Serialize scalar value
- **struct** ... directory, function files used to create low-level structure elements
  - struct/struct\_objattrib ... function file, Create attribute object (atomic attribute element, AAE)
  - struct/struct\_objdata ... function file, Create data object (atomic data element, ADE)
  - struct/struct\_objref ... function file, Create reference object (atomic reference element, ARE)
- **tex** ... directory, subsidiary functions used to serialize data structures to TeX code
  - tex/tex\_def\_csvarray.m ... function file, Serialize array variable to TeX code (comma-separated list, e.g. version numbers)
  - tex/tex\_def\_dotarray.m ... function file, Serialize short array variable to TeX code (dot-separated list, e.g. structure path)
  - tex/tex\_def\_scalar.m ... function file, Serialize scalar value to TeX code
  - tex/tex\_def\_tabarray.m ... function file, Serialize array value to TeX code (tabulated)
  - tex/tex\_def\_tabmatrix.m ... function file, Serialize matrix value to TeX code (tabulated)
  - tex/tex\_serialize.m ... function file, Serialize single value of various data types
  - tex/tex\_settings.m ... function file, Create data structure containing the TeX code serialization settings
  - tex/tex\_struct.m ... function file, Serialize data structure(s) to TeX code
  - tex/tex\_struct\_export.m ... function file, Export data structure(s) to TeX code file
  - tex/tex\_struct\_objattrib.m ... function file, Serialize atomic attribute element to TeX code
  - tex/tex\_struct\_objdata.m ... function file, Serialize atomic data element to TeX code
  - tex/tex\_struct\_objref.m ... function file, Serialize atomic reference element to TeX code
- **tmp** ... directory, temporary directory used to store exported files (fallback option)
- **tools** ... directory, subsidiary functions called by the main program functions
  - tools/tool\_get\_maturity.m ... function file, Extract maturity time array from ultrasonic test substructure of a dataset
  - tools/tool\_gui\_dsload.m ... function file, Select and load GNU Octave binary dataset file (*.oct), GUI
  - tools/tool\_gui\_selchn.m ... function file, Select channel of ultrasonic pulse transmission test, GUI
  - tools/tool\_gui\_selsig.m ... function file, Select signal(s) from ultrasonic pulse transmission test, GUI
  - tools/tool\_gui\_selsub.m ... function file, Select substructure of dataset and return the structure path, GUI
  - tools/tool\_gui\_seltem.m ... function file, Select channel of specimen temperature test, GUI


## Installation instructions

1. Copy the program directory to a location of your choice. e.g. **working_directory**.   
2. Open GNU Octave.   
3. Change the working directory to the program directory. e.g. **working_directory**.   


## Usage instructions

1. Adjust the settings in the function files: dsexporter\_settings.m, ./json/json\_settings.m, ./tex/tex\_settings.m   
2. Run GNU Octave.   
3. Initialize program.   
4. Execute any of the function files.   


### Initialize program

The 'init' command initializes the program. This is only required once before executing all the other functions. The command is adding the subdirectories included in the main program directory to the 'path' environment variable.

```
   octave: >> init;   
```


### Execute function file at the command line interface

The following commands are the main functions of the program. The function parameters are documented in the respective function files (see also section: Help).
The functions can be used either in interactive or non-interactive mode. In interactive mode, dialogue windows are used and user input is expected. That mode is always activated when necessary or all function parameters are missing.

```
   octave: >> dsexporter_examples(); 
   octave: >> [ss] = dsexporter_settings(); 
   octave: >> [fp1, fp2] = dsexporter_sig2csv(p_ss, p_odp, p_ifp, p_cn, p_si, p_i0, p_i1, p_del);   
   octave: >> [fp] = dsexporter_sig2snd(p_ss, p_odp, p_ifp, p_cn, p_si, p_ff, p_fs);   
   octave: >> [fp1, fp2] = dsexporter_tem2csv(p_ss, p_odp, p_ifp, p_tcn, p_del);   
   octave: >> [ds] = dsexporter_substruct(p_ss, p_fp, p_sp);   
   octave: >> [fp] = dsexporter_substruct2json(p_ss, p_odp, p_ifp, p_dsp);   
   octave: >> [fp] = dsexporter_substruct2tex(p_ss, p_odp, p_ifp, p_dsp);     
```


## Help and Documentation

All function files contain an adequate function description and instructions on how to use the functions. This documentation can be displayed in the GNU Octave command line interface by entering the following command:

```
   octave: >> help function_file_name;   
```


## Related data sources

Datasets from which data can be exported with these scripts are made available at the repository of Graz University of Technology under an open licence (Creative Commons Attribution 4.0 International, CC BY 4.0). The data records listed below contain the raw data, the compiled datasets and a technical description of the record content.


### Data records

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 1, Cement Paste at Early Stages". Graz University of Technology. [doi: 10.3217/bhs4g-m3z76](https://doi.org/10.3217/bhs4g-m3z76)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 3, Reference Tests on Air". Graz University of Technology. [doi: 10.3217/ph0jm-8ax76](https://doi.org/10.3217/ph0jm-8ax76)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 4, Cement Paste at Early Stages". Graz University of Technology. [doi: 10.3217/f62md-kep36](https://doi.org/10.3217/f62md-kep36)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 5, Reference Tests on Air". Graz University of Technology. [doi: 10.3217/bjkrj-pg829](https://doi.org/10.3217/bjkrj-pg829)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 6, Reference Tests on Water". Graz University of Technology. [doi: 10.3217/hn7we-q7z09](https://doi.org/10.3217/hn7we-q7z09)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 7, Reference Tests on Aluminium Cylinder". Graz University of Technology. [doi: 10.3217/azh6e-rvy75](https://doi.org/10.3217/azh6e-rvy75)   


## Related software

### Dataset Compiler, version 1.1:

The referenced datasets are compiled from raw data using a dataset compilation tool implemented in the programming language of GNU Octave 6.2.0. To understand the structure of the datasets, it is a good idea to look at the soure code of that tool. Therefore, it was made publicly available under the MIT license at the repository of Graz University of Technology.

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Data set compiler (1.1)". Graz University of Technology. [doi: 10.3217/6qg3m-af058](https://doi.org/10.3217/6qg3m-af058)

[!NOTE]
*Dataset Compiler* is also available on **github**. [Dataset Compiler](https://github.com/jakobharden/phd_dataset_compiler)


### Dataset Viewer, version 1.0:

*Dataset Viewer* is implemented in the programming language of GNU Octave 6.2.0 and allows for plotting measurement data contained in the datasets. The main features of that script collection cover 2D plots, 3D plots and rendering MP4 video files from the measurement data contained in the datasets. It is also made publicly available under the MIT licence at the repository of Graz University of Technology.

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Dataset Viewer (1.0)". Graz University of Technology. [doi: 10.3217/c1ccn-8m982](https://doi.org/10.3217/c1ccn-8m982)

[!NOTE]
*Dataset Viewer* is also available on **github**. [Dataset Viewer](https://github.com/jakobharden/phd_dataset_viewer)


## Revision and release history

### 2023-08-26, release, version 1.0

- published/released version 1.0, by Jakob Harden   
- url: [https://doi.org/10.3217/9adsn-8dv64](Repository of Graz University of Technology)   
- doi: 10.3217/9adsn-8dv64   

### 2023-12-09, release, version 1.1

- published/released version 1.1, by Jakob Harden   
- added sound file export function and sound file examples
- url: [https://doi.org/10.3217/d3p6m-w7d64](Repository of Graz University of Technology)   
- doi: 10.3217/d3p6m-w7d64   


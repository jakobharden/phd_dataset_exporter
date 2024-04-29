# Minimal working LaTeX export example

This file contains the instructions needed to compile the minimal working LaTeX export example.
The exported data used in this example is taken from the dataset "ts1\_wc040\_d50_6.oct", which is freely available at the following URL: [https://doi.org/10.3217/bhs4g-m3z76](https://doi.org/10.3217/bhs4g-m3z76)

The output of the compilation process is the PDF file *example.pdf*. TeX Live was used for this application example (see also: [TeX Live](https://tug.org/texlive/)).


## Files

```
   latex/   
   ├── example.bib   
   ├── example.pdf   
   ├── example.tex   
   ├── oct2texdefs.tex   
   ├── README.html   
   ├── README.md   
   ├── ts1_wc040_d50_6_meta_ser.tex   
   ├── ts1_wc040_d50_6_meta_set.tex   
   ├── ts1_wc040_d50_6_sig_c.colheads   
   ├── ts1_wc040_d50_6_sig_c.csv   
   ├── ts1_wc040_d50_6_sig_s.colheads   
   ├── ts1_wc040_d50_6_sig_s.csv   
   ├── ts1_wc040_d50_6_tem_t1-t4.colheads   
   ├── ts1_wc040_d50_6_tem_t1-t4.csv   
   └── ts1_wc040_d50_6_tst.env.tex   
```


## LaTeX document compilation instructions

1. Run data export, function file *dsexporter\_examples.m*   
2. Open the file *example.tex* in a LaTeX IDE of your choice.   
3. Make sure that all required LaTeX packages are installed on your system (see preamble section in *example.tex*).   
4. Compile *example.tex* using a *pdflatex* compiler (pdflatex -synctex=1 -interaction=nonstopmode %.tex).   


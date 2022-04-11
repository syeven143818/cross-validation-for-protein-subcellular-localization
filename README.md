# predict protein subcellular localization

![PredictProtein](/images/img1.png)

## Description
Perform k-fold cross-validation for protein subcellular localization problem.

### cmd
```R
Rscript Rfile.R --fold k --input Archaeal_tfpssm.csv --output performance.csv
```
* Perform *k*-fold cross-validation
* % of training, % of calibration, % of testing= *k*-2, 1, 1

The following shows the example of the 5-fold cross validation.
![cross-validation](/images/img2.png)

## Input: Archaeal_tfpssm.csv

[Archaeal_tfpssm.csv download](https://drive.google.com/file/d/1L-gv1dPaEonnaASeBtakePT1t3FJwPFI/view?usp=sharing)

This CSV doesn't contain a header. The information of columns as below:

V2: labels of proteins

* CP: Cytoplasmic
* CW: Cell Wall
* EC: Extracellular
* IM: Inner membrane

V3 ~ V5602: the gapped-dipeptide features of each protein


## Output: performance.csv

* accuracy = *P*/*N*, average of *k*-fold cross-validation

set|training|validation|test
---|---|---|---
fold1|0.93|0.91|0.88
fold2|0.92|0.91|0.89
fold3|0.94|0.92|0.90
fold4|0.91|0.89|0.87
fold5|0.90|0.92|0.87
ave.|0.92|0.91|0.88


## References
* Chang, J.-M. M. et al. (2013) [Efficient and interpretable prediction of protein functional classes by correspondence analysis and compact set relations](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0075542). *PLoS ONE* 8, e75542.
* Chang J-M, Su EC-Y, Lo A, Chiu H-S, Sung T-Y, & Hsu W-L (2008) [PSLDoc: Protein subcellular localization prediction based on gapped-dipeptides and probabilistic latent semantic analysis](https://onlinelibrary.wiley.com/doi/full/10.1002/prot.21944). *Proteins: Structure, Function, and Bioinformatics* 72(2):693-710.

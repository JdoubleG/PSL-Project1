# __CS 598 Practical Statistical Learning__
## __Project 1: Predicting Housing Prices in Ames, Iowa__

October 17, 2022


## __Team member contributions__:

James Garijo-Garde (jamesig2):
- general code stub for training/testing
- identification of variables to log/winsorize
- Linear Regression model tuning
- written report

Matthew Lind (lind6):
- data cleaning / processing functions
- written report
- Tree model

## __Introduction__:

The data set was derived from a [Kaggle competition](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques/overview/description) for the Ames, Iowa housing data.  The objective is to use the available housing data to predict future home sale prices in the area.  Two methods were used to predict home sales: Elastic Net and XGBoost.

## __Preprocessing__:

The data set contains home sales for years 2006 through 2010 with 2930 rows of data across 83 columns with 4 types of data: continuous, discrete, ordinal, and categorical (nominal).

### Repair
Only one variable (Garage_Yr_Blt) contained missing values.  The missing values were replaced with zeros, "repairing" the data.

### Dropped Variables
Several variables demonstrated little or no correlation to Sale_Price of the home, so they were dropped from the model.

### Nominal Variables
Categorical variables utilizing levels of nominal values were converted to distinct binary variables (one-hot encoding) with each binary variable representing one nominal value in the original variable.  For each converted categorical variable, K-1 binary variables were generated where K is the number of levels in the variable when K > 2.

### Winsor Method
Numeric variables demonstrating high correlation to Sale_Price but containing extreme outliers were processed using the winsor method to clamp outliers to specify quantiles.


### Logarithmic Transformation
We identified several variables with a relationship appearing logarithmic to Sale_Price, however, due to the strong performance of our models before adding the logarithmic transformations, we decided against transforming any data logarithmically.

## __Discussion__:

Training was conducted over 10 splits with each split tested over different subsets of the data set.

### __Linear Regression - Elastic Net__:

Elastic net uses the alpha parameter to specify the ratio of L1 penalty to L2 penalty: an alpha value of 0 is equivalent to ridge regression, while an alpha value of 1 is equivalent to lasso. We selected the alpha value by manually binary searching through possible values with a precision of one number after the decimal point. A value of 0.5 was chosen via this method.

After selecting an alpha value, we compared s values of lambda.min to lambda.1se and the default value of the entire sequence used to create the model in the predict function. lambda.min performed best.

System specifications:

|   |    |
| --- | --- |
| System | Framework Laptop |
|	CPU | Intel i7 1260P, 12 cores (16 logical) @ 2.5 GHz |
| GPU | AMD Radeon RX 6600, Thunderbolt 3 eGPU |
| Memory | 16 GB DDR-4 @ 3200 MHz |
| Storage | Seagate FireCuda 530, PCIe gen. 4 NVMe, 1 TB |
| OS | Microsoft Windows 11 Education |
| R Version | 4.2.1 |


Elastic Net Hyperparameters:
- __alpha__: 0.5
- __s__: lambda.min

Benchmarks: 

| Split | Time | RMSE |
| --- | --- | --- |
| 1  | 1.19999999995343 | 0.124628384771047 |
| 2  | 1.07000000000698 | 0.118403236441471 |
| 3  | 1.36000000004424 | 0.123265305612458 |
| 4  | 1.18000000005122 | 0.122803429417362 |
| 5  | 1.04999999998836 | 0.111930337886272 |
| 6  | 1.34999999997672 | 0.134311146078248 |
| 7  | 1.39000000001397 | 0.126345650528322 |
| 8  | 1.59000000002561 | 0.121589583453122 |
| 9  | 1.26000000000931 | 0.132570227078566 |
| 10 | 1.05999999999767 | 0.124052457975485 |

### __Boosting Tree using XGBoost__:

XGBoost is a tree based method which can be used for regression utlizing extreme gradients to improve performance.  XGBoost 

The boosting tree method was trained on the following system:

|  |  |
| --- | --- |
| System | Dell Precision Workstation T7820 |
| CPU | Intel Xeon 6242R Processor, 20 cores (40 logical), 35 MB L2 cache |
| GPU | NVidia Quadro RTX 4000, PCIe gen. 3, 8 GB GDDR-6 RAM, 2304 CUDA cores |
| Memory | 48 GB DDR-4 @ 2600 MHz |
| Storage | Samsung 980 Pro, PCIe gen. 3 NVMe, 1 TB |
| OS | Microsoft Windows 10 Pro |
| R version | x.x.x |
^^^ TODO

The xgboost library has many hyperparameters which can be adjusted to improve results.  Only a small subset were actually used in training:

- __parameter 1__: explanation 1 ...
- __parameter 2__: explanation 2 ...
- __parameter 3__: explanation 3 ... 

The training was conducted over 10 splits with the following observed running times and Root Mean Squared Error (RMSE):

| Split | Time | RMSE |
| --- | --- | --- |
| 1  | 00:01 | 0.123 |
| 2  | 00:01 | 0.123 |
| 3  | 00:01 | 0.123 |
| 4  | 00:01 | 0.123 |
| 5  | 00:01 | 0.123 |
| 6  | 00:01 | 0.123 |
| 7  | 00:01 | 0.123 |
| 8  | 00:01 | 0.123 |
| 9  | 00:01 | 0.123 |
| 10 | 00:01 | 0.123 |

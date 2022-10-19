# __CS 598 Practical Statistical Learning__
## __Project 1: Predicting Housing Prices in Ames, Iowa__

October 17, 2022

## __Team member contributions__:

James Garijo-Garde (jamesig2):
- General code stub for training/testing
- Identification of variables to log/winsorize
- Linear Regression model tuning
- Written report

Matthew Lind (lind6):
- Implentation of full training/testing code.
- Support code for plotting/analysis of data
- Tree model

## __Introduction__:

The data set was derived from a [Kaggle competition](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques/overview/description) for the Ames, Iowa housing data.  The objective is to use the available housing data to predict future home sale prices in the area.  Two methods were used to predict home sales: Elastic Net and XGBoost.

## __Preprocessing__:

The data set contains home sales for years 2006 through 2010 with 2930 rows of data across 83 columns with 4 types of data: continuous, discrete, ordinal, and categorical (nominal).

### Repair
Only one variable (Garage_Yr_Blt) contained missing values.  The missing values were replaced with zeros, "repairing" the data.

### Dropped Variables
Several variables demonstrated little correlation to Sale_Price of the home:
- Condition_2, Heating, Latitude, Longitude, Low_Qual_Fin_SF, Misc_Feature, Pool_Area, Pool_QC, Roof_Matl, Street, Utilities

These variables lack range of values to be useful in prediction:
- Mas_Vnr_Type, Lot_Config, Roof_Style, Pool_Area, Mo_Sold, Year_Sold

These variables exhibited negative or no correlation to Sale_Price prediction:
- BsmtFin_SF_1, Enclosed_Porch, Kitchen_AbvGr, Misc_Val, BmstFin_SF_2

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

The XGBoost tree method was trained on the following system:

|  |  |
| --- | --- |
| System | Dell Precision Workstation T7820 |
| CPU | Intel Xeon 6242R Processor, 20 cores (40 logical), 35 MB L2 cache |
| GPU | NVidia Quadro RTX 4000, PCIe gen. 3, 8 GB GDDR-6 RAM, 2304 CUDA cores |
| Memory | 48 GB DDR-4 @ 2600 MHz |
| Storage | Samsung 980 Pro, PCIe gen. 3 NVMe, 1 TB |
| OS | Microsoft Windows 10 Pro |
| R version | 4.2.1 |

The xgboost library has many hyperparameters which can be adjusted to improve results.  Only a small subset were actually used in training:
- __eta__: Controls rate of learning and used to control overfitting.  Typical values specified in range [0...1].  Values tested were: 0.01, 0.025, 0.035, 0.1, 0.04, 0.05, 0.065, 0.5 and 1.0.  The best eta was roughly 0.05 - 0.065 depending on the rounds and depth parameters.
- __rounds__: Maximum number of boosting iterations.  More rounds means more  decision trees are built for boosting, but also more computation resources and time involved.  Values tested were 100, 150, 175, 250, 500, 1000, 1500, 2500, 5000.  The default value was 5000, but lowered by half until a best compromise was reached.  Lower rounds improved execution time greatly but reduced accuracy of prediction.  Lowest value satisfying benchmarks was 175.
- __subsample__: Subsample ratio of the training distance.  Ratio of how many data instances are collected to grow trees to prevent overfitting.  Values tested were: 0.01, 0.1, 0.35, 0.5, 0.65, 0.75, and 1.0.  Best value was 0.5. as both higher and lower values resulting in individual splits exceeding the benchmark while extremely low subsample greatly increased RMSE.
- __maxdepth__: Maximum depth of the tree.  Lower values resulted faster computation but poorer RMSE.  Higher values slowed execution time, but did not produce significantly better RMSE.  RMSE appeared to peak around value of 9.  Values tested were 1, 3, 6, 9, 12, and 50.  Best value was between 6 and 9.

The training was conducted over 10 splits with the following observed running times and Root Mean Squared Error (RMSE):

XGBoost hyperparameters:
__eta__= 0.05, __rounds__= 1000, __max depth__= 6, __subsample__= 0.5

| Split | Time (s) | RMSE |
| --- | --- | --- |
| 1  | 18.429 | 0.115975659748044 |
| 2  | 18.590 | 0.120204730438156 |
| 3  | 18.219 | 0.112864671573723 |
| 4  | 18.120 | 0.11422704651545 |
| 5  | 18.560 | 0.110223450510811 |
| 6  | 18.939 | 0.127159680916838 |
| 7  | 18.380 | 0.129536942732046 |
| 8  | 18.359 | 0.127812048776704 |
| 9  | 18.510 | 0.128504951720723 |
| 10 | 18.350 | 0.123814368393756 |

## __Comments__

During testing it was noticed custom quantile values for each Winsorized variable did not improve RMSE.  Quantile was set to 0.95 for best results.

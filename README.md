# __CS 598 Practical Statistical Learning__
## __Project 1: Predicting Housing Prices in Ames, Iowa__

October 17, 2022


## __Team member contributions__:

(__TO DO__: edit into nice prose)

James Garijo-Garde (jamesig2):
- general code stub for training/testing
- Linear Regression model

Matthew Lind (lind6):
- data cleaning / processing functions
- written report
- Tree model

## __Introduction__:

The data set was derived from a [Kaggle competition](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques/overview/description) for the Ames, Iowa housing data.  The objective is to use the available housing data to predict future home sale prices in the area.  Two methods were used to predict home sales: Elastic Net and XGBoost.  Elastic Net is a linear regression model incorporating the Lasso and Ridge models with regularization and implemented using the GLMNet library.  XGBoost is a tree based method which utilizes extreme gradients to improve results.  Both methods were available in the R programming language as libraries.

## __Preprocessing__:

(__TO DO__: get really specific on what steps were performed in each of the sections listed here, including variable names)

The data set contains home sales for years 2006 through 2010 with 2930 rows of data across 83 columns with 4 types of data: continuous, discrete, ordinal, and categorical (nominal).  Data was modified to be more suitable towards machine learning as some variables were recorded in a manner which are more convenient for humans than for machines.  This includes eliminating irrelevant data and outliers, converting data to a format suitable for numeric computation,  redefine variable when it was not experessed elegantly, or contained strong correlation to another very similar variable.

### Repair
Only one variable (Garage_Yr_Blt) contained missing values.  Inspection of records in the data indicated the homes with the missing values did not have a garage.  Therefore, the missing values were replaced with zeros.

After the data was repaired, a copy was made for each training method employed so data could be further transformed in a manner appropriate for the training method.

### Dropped Variables
Several variables demonstrated little or no correlation to Sale_Price of the home, so they were dropped from the model (e.g. Latitude, Longitude, PID, ...)

### Categorical Variables
Categorical variables utilizing levels as a rating system of increasing quality were converted to ordinal variables with integer values.

### Ordinal Variables
Categorical variables utilizing levels of nominal values were converted to distinct binary variables (one-hot encoding) with each binary variable representing one nominal value in the original variable.  For each converted categorical variable, K-1 binary variables were generated where K is the number of levels in the variable when K > 2.

### Winsor Method
Numeric variables demonstrating high correlation to Sale_Price, but contained extreme outliers, were processed using the winsor method to clamp outliers to a specified quantile - usually 95%.


## __Description of models__:

(__TO DO__: expand on the description of the models, describe how they were employed in training/testing, implementation details, how hyperparameter values were chosen, etc...)

### Linear Regression: 

Elastic Net is a linear regression method utilizing regularization of the L1 and L2 penalties as found in the Lasso and Ridge regression methods respectively.  Elastic net is ...

### Tree based method: 

XGBoost is a tree based method which can be used for regression utlizing extreme gradients to improve performance.  XGBoost 

## __Discussion__:

(__TO DO__: Double-check the steps listed below are accurate.  Expand on descriptions of the hyperparameters for each method, what they are, what they do, why we chose to tune them and the logic behind doing so, etc... )

Training was conducted over 10 splits with each split tested over different subsets of the data set.  Each split involved reading the train data, transforming the train data for the specific regression method employed, fit the model to the log of the Sale_Price variable, and record predictions from the trained model.  The test data is then read and transformed using the same transformations as applied to the training model to ensure the design matrix is of same configuration.  The train model is then applied to the test data to perform predictions, and record results.  Finally, the predictions are measured against the ground truth so a Root Mean Squared Error score (RMSE) can be computed.

0. start wall clock for the split
1. read train data
2. transform train data
3. fit model on the train data
4. record train predictions
5. read test data
6. transform test data to conform to train data design matrix specifications.
7. perform predictions on test data.
8. record predictions and write to file.
9. read predictions from file to compute RMSE.
10. stop wall clock for the split.

### __Linear Regression - Elastic Net__:


System specifications:

|   |    |
| --- | --- |
| System | Framework Laptop |
|	CPU | Intel i7 1260p, 12 cores (16 logical) @ 2.5 GHz |
| GPU | AMD Radeon RX6600 |
| Memory | 16 GB DDR-4 @ 3200 MHz |
| Storage | Seagate Solid State Drive, PCIe x4 NVMe |


Elastic Net Hyperparameters:
- __parameter 1__: explanation 1 ...
- __parameter 2__: explanation 2 ...
- __parameter 3__: explanation 3 ... 

Benchmarks: 

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

### __Boosting Tree using XGBoost__:

The boosting tree method was trained on the following system:

|  |  |
| --- | --- |
| System | Dell Precision Workstation T7820 |
| CPU | Intel Xeon 6242R Processor, 20 cores (40 logical), 35 MB L2 cache |
| GPU | NVidia Quadro RTX 4000, PCIe x3, 8 GB GDDR-6 RAM, 2304 CUDA cores |
| Memory | 48 GB DDR-4 @ 2600 MHz |
| Storage | Samsung 980 Pro, PCIe x3 NVMe, 1 TB |
| OS | Microsoft Windows 10 Pro |

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


### __Results / Conclusion __:

(__TO DO__: Discussion of findings, what worked, what didn't, interesting discoveries along the way (good or bad), etc...)

### Remarks:

(__TO DO__: optional.  Any closing thoughts on the project as a whole)

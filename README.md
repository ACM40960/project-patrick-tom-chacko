<h1>Disease Modelling and Prediction using Neural Network in R</h1>
<h2>Contents</h2>
1) Introduction <br>
2) Dataset & Metrics <br>
3) Installation <br>
4) Automated Pre-processing of data <br>
5) Principal Component Analysis Feature Selection <br>
6) Neural Network Architecture <br>
7) Neural Network Performance <br>
8) Limitations <br>
9) Future Scope <br>
10) Conclusion
11) Resources and References


<h2> 1. Introduction </h2>
<br>
There are 56 columns given  which are measurements of various health characteristics, main aim of the study is to use a model to predict the medical condition based on these 56 characteristics<br>

Furthermore, we also want to see if there is redundancy in these 56 characteristics such that fewer of them need to be discovered to identify the presence of the old age-related medical condition. <br>

Identifying fewer important characteristics could help In diagnosing and treatment of the medical condition faster and also the reduced number of tests to identify these characteristics can save money and make disease prediction faster and economical



<h2> 2. Dataset & Metrics</h2>
<h3>Dataset</h3>
AB-GL = Fifty-six anonymized health characteristics all numeric.<br>
EJ = categorical variable <br>
Class = Binary target, 1 indicates the subject has been diagnosed with one of the three conditions, 0 indicates they have not.<br>
<h3>Metric</h3>
Since we have highly unbalanced classes for a fair assessment it would be better to use the F1 score as the accuracy metric to train the Neural Network. F1 is a harmonic mean between Precision and Recall.<br><br>


F1 score = 2 x (Recall x Precision)/(Recall + Precision)<br><br>
Precision = TP/(TP+FP) <br>
Recall = TP/(TP+FN)

<h2> 3. Installation</h2>
- Install R-Studio <br>
- Download the R file to your local machine <br>
- run the following line of codes in the console 
"install.packages('keras')"; <br>
<br>
Sometimes RStudio has errors with Neural Networks and TensorFlow, if any addition to the code is done and the code throws an error then using the RStudio in Anaconda would fix the issue as the IDE is integrated with all the required dependencies.

<h2> 4. Automated Pre-Processing </h2>

![Picture of Pre-Processing a random document](https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/1c2881bc-1a70-4d49-a715-515b702d21cd) 

There is a function in the first line of code that does the following functions on the provided dataset :- <br>
1) Renames the row names with the column ‘Id’<br>
2) Missing Value Imputation of the numeric features by the class means (Positive/Negative)<br>
3) Standardizes the dataset by mean and standard deviation<br>
4) Categorical variable ‘EJ’ hot key encoding.<br>

<h2> 5. Principal Components Analysis for Feature Selection</h2>


![PC and Var](https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/d7859098-7968-4b2a-a9ab-2bfb88f2f544)


<br>
The code is included in the DNN_Classifier.R file, PCA results tell us that 40 components are needed to explain atleast 95% of variation in Data, the reason for high number of PCA could be any of the following :- <br>
1) Intrinsic Data Complexity <br>
2) Noise in the Data<br>
3) Non-linear relationship<br>
4) Correlated Features<br>
<br>
Result – PCA could not be used as the loadings of all the variable were significantly small and the choice of high loading variables was rejected.<br>
Thus Feature  Selection for the Neural Network is not taken further from here, all the features are selected. <br>
PRCOMP was used to compute the Principal Components of the data.

<h2> 6. Neural Network Architecture</h2>

<img width="602" alt="NEURAL NET ARCHITECTURE" src="https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/ad67c32b-5231-4ce4-afcb-7e9cd09d5954">
<br>
Model was trained on 556 Observations and Validated in sample with a Validation Split of 0.4 and 61 Observations were kept as test set for out sample Evaluation. 150 epochs were considered for training the DNN.<br>

<img width="242" alt="Class barchart" src="https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/40acb963-a274-4805-8885-fb4ccff21566">

Since the number of Positive Cases were very less in comparison with the Negative Cases, F1 metric was used to train the Model.To increase the Model Performance class weights had to be biased, hence the probability of choosing a class 1 observation from the dataset was made higher than the existing probability.

<h2> 7. Neural Network Performance</h2>
<h3>Binary cross entropy Loss</h3>
<img width="381" alt="Loss of classification accuracy" src="https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/a7080459-71ad-4e51-8f83-c905a907905d", title = 'Binary cross entropy Loss'>
<h3>Classification accuracy</h3>
<img width="382" alt="classification accuracy" src="https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/9212ee44-0d2d-403f-b9b0-ddc1a610be7c ", title = 'Classification accuracy'>
<h3>F1 score</h3>
<img width="381" alt="F1 score" src="https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/cfa1e03b-2874-40f1-b474-5e7723d84097", title = 'F1 score'>

<br><b>Discussion</b><br>
The graphs show that the training and validation curve seems to have reached convergence and we can see the importance of using F1 Metric. The in-sample validation for Classification Accuracy is nearly 99% whereas the F1 score gives a more realistic accuracy of 73% approx. Using batch Normalization in each layer has decreased the in-sample validation f1 accuracy from a max of 72.5% but has reduced the overfitting. Batch Normalization is not considered hereafter consideration with Out of Sample Evaluation.<br>

<h3>OUT OF SAMPLE EVALUATION</h3>
<img width="429" alt="image" src="https://github.com/ACM40960/project-patrick-tom-chacko/assets/134104897/2ece54fc-c15c-47d2-b1dd-7519ace1105c">

From the Out of Sample Evaluation, we can see that the Model is consistent with unseen Observations and yields a f1-Accuracy of 70.6% approx. The validation in-sample and out-sample sets agree with each other hence nullifying the effect of overfitting


<h2> 8. Limitations</h2>
1)  Highly Unbalanced cases <br>
2) Tuning of Neural Networks<br>
3) Ensemble NN Classifiers<br>
4) Using Non-Linear Dimension Reduction Techniques<br>
5) Large Number of Parameters<br>
6) Computational Cost for NN training and evaluation<br>
7) Lack of Interpretability<br>

<h2> 9. Future Scope </h2>
1) Tuning of Neural Network in a grid of parameters and Ensemble NN Classifiers. <br>

2) Fully Automate the Pre-Processing step instead of selecting the Missing variable by observation and being mean imputed.<br>

3) Bootstrapping would be an efficient but computationally costly technique that could increase the Model Performance.<br>

<h2> 10. Conclusion </h2>

1) Principal Components cannot be used here for feature selection. Implying the information is Unique among different variables and there is a need for approximately 41 Principal Components to explain at least 95% of Variation in the data, which is not significantly very different from 56 variables.<br>

2) The Neural Network deployed is able to achieve an F1-score of 73% approx. in the in-sample validation and a 70% approx score on the out-sample validation. The model is consistent with the output.<br>
3) Systematic Tuning using the grid search can improve the Model Performance if required at the cost of computational resources.<br>

<h2> 11. Resources and References</h2>
Images <br>
Pre-Processing -Getty Images/iStockphoto

Review of Literature
1) Sadek, Ramzi M., et al. “Parkinson’s Disease Prediction Using Artificial Neural Network.” Parkinson’s Disease Prediction Using Artificial Neural Network, 1 Jan. 2019<br>
2) Cheng-Hsiung Weng and Tony Cheng-Kui Huang and Ruo-Ping Han, “Disease Prediction With Different Types of Neural Network Classifiers.” Disease Prediction With Different Types of Neural Network Classifiers - ScienceDirect, 21 Aug. 2015, https://doi.org/10.1016/j.tele.2015.08.006.<br>
3) S. P. Rajamhoana, C. A. Devi, K. Umamaheswari, Kiruba, K. Karunya and R. Deepika, "Analysis of Neural Networks Based Heart Disease Prediction

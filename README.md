<h1>Disease Modelling and Prediction using Neural Network in R</h1>
<h2>Contents</h2>
1) Introduction <br>
2) Dataset & Metrics <br>
3) Installation 
4) Automated Pre-procesing of data <br>
5) Principal Component Analysis Feature Selection <br>
6) Neural Network Architecture <br>
7) Neural Network Performance <br>
8) Limitations <br>
9) Future Scope <br>

<h2> Introduction </h2>
<br>
There are 56 columns given  which are measurements of various health characteristics, main aim of the study is to use a model to predict the medical condition based on these 56 characteristics<br>

Furthermore, we also want to see if there is redundancy in these 56 characteristics such that fewer of them need to be discovered to identify the presence of the old age-related medical condition. <br>

Identifying fewer important characteristics could help In diagnosing and treatment of the medical condition faster and also the reduced number of tests to identify these characteristics can save money and make disease prediction faster and economical



<h2> Dataset & Metrics</h2>
<h3>Dataset</h3>
AB-GL = Fifty-six anonymized health characteristics all numeric.<br>
EJ = categorical variable <br>
Class = Binary target, 1 indicates the subject has been diagnosed with one of the three conditions, 0 indicates they have not.<br>
<h3>Metric</h3>
Since we have highly unbalanced classes for a fair assessment it would be better to use the F1 score as the accuracy metric to train the Neural Network.


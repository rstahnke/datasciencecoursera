=========================
Final Assignment Data Set
=========================

The data set “mydata.txt” was created in R using the commands given in the script “runanalysis.R”. The variables created by the script are described in “Code_Book.txt”.

“runanalysis.R” performs the following steps:
1. Reads the Human Activity Recognition Using Smartphones data set into R and then combines training and test portions of the data and labels all the columns/features that give the measurements for the experiment.
2. Subject labels are read in for both the training and test data. Then all the feature data are combined with the subject and activity labels. (Note: columnns 461 to 501 with identical column names from the way they were labeled in the original data set are deleted.)
3. Meaningful labels are given to the activity labels in the “label” column.
4. Selects only the columns/features that give “mean” or “stdev” data (plus the “labels and subject” columns).
5. Melta the data into long form and then recasts it to calculate the means for each of the features measured in the data set grouped by subject and label. The resulting data set is written to “mydata2.txt”.

The data are derived from the following data set:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.


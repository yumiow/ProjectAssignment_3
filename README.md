This is for Getting and Cleaning Data to output a tidy and clean data set. (run_analysis.R)

This is how my R script works to perform cleaning, organizing and generating the output:

1. Download UCI HAR Dataset zip file from directed URL, unzip the file.
2. Read train, test, etc. data sets by using read.table from directory. Merge the datasets using cbind.
3. Use grep, extract mean and standard deviation; clean column names, find correspinding activity type by join data sets, clean up data frame orders by reordering.
4. After merging, calculated mean by the group of activities and subjects then export the data set to txt file.

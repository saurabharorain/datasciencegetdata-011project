
## Introduction

This Code Book is used the define the variable and transformation on the original data.

## Variable

As per the requirement of the project, we have extracted all the variable defined in features.txt, which have a mean or standard deviation.

1. The first variable is the subject. we have 30 users dataset, this would point to one of them.
2. The second variable is the activity type.
From the third onwards all the mean and standard deviation are present. All variables are normalize vector in the range [1,-1]


## Transformation

Let me now describe the transformation details

### Reading common datasets and finding required features

1. reading common data set. activity_labels.txt and features.txt
2. extracting the required features from features.txt

In this section, we primarly read the files and find the features need using 
regular expression match for mean and standard deviation.
See lines 42-54 in run_analysis.R

### Read Train/ Test datasets and merge

We read the datasets (see readData, line 12-40) and merge the same in line 61.

During reading, we use the required features to project and exclude the 
unnecessary columns.

Later, we merge the dataset using rbind.

### Cleanup / Aggregate and Tidy up

In this phase(lines 64-74) , we remove unnecessary columns and aggregate on
subjects and activity.

Later,we tidy up the data moving the column.

### Write tidy file.

Finally, we write out the file using write.table

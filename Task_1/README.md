# Tools Used:
Python

# Following Changes are made on the dataset:

+  On initial inspection of dataset, there were some INT datatype columns that contained True/False values as 0/1, an Object datatype column that contained date values, some Null values.
+  The rows with Null values were dropped.
+  The Text/Object values were changed to Title case.
+  The date formats were changed to mm-dd-yyyy format, as this is the format that DateTime64 datatype expects.
+  Column headers are renamed to more meaningful names.
+  The columns with Object datatypes representing boolean data were changed to Bool datatype and the one with date was changed to DateTime64 datatype.
+ The cleaned dataset was then written back to the CSV file.
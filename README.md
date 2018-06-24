# ottakring
I made this package to be able to use Stata through R directly to execute Stata's survey command.
The results of the (for now) only function svy_mean are returned to R as a data.frame and can be used for plotting (or other things).
Invoking the function leads to the creation of a temporary folder in the working directory in which the data passed to the function and the created do file are saved to. The do file will be executed in the background and a matrix will be saved as a txt. After loading the txt to R, the folder will be deleted.  
  
  
The name of the package is an hommage to Ottakring, a beautiful quarter of Vienna, where the package was programmed.

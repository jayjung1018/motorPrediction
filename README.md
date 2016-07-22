# Motor Prediction
This project uses a MATLAB script to predict the x and y positions of a monkey's finger and the corresponding EEG readings from 40 neurons

##To Run
Run the script "motionPrediction.m" - x and y correlations as well as a movie showing the actual and predicted x and y points should appear

## Description
Uses the optimal linear decoder method as described by the paper by Warland (pdf provided - warland97). 
Given a dataset of monkey EEG readings, the first 400 points are used as a testing set, and the rest is used as a training set.

The feature matrix, R, is created using the EEG readings for both the testing and the training sets. The matrix looks like this:

![](https://github.com/jayjung1018/motorPrediction/blob/master/r.PNG)

_v_ represents the number of neurons (40 in this case).    
N represents a time window (20 in this case). For example, in the first row, we take the first N points for all 40 neurons.   
M represents the total number of time bins (1972 in this case) - this implies we have 1992 total points for each neuron.

We calculate the filter weights matrix, f, and finally the predicted finger positions, u, with the equations below

![](https://github.com/jayjung1018/motorPrediction/blob/master/f.PNG)    
![](https://github.com/jayjung1018/motorPrediction/blob/master/u.PNG) 

In this case, we compared the predicted positions from the testing set to the actual set of 400 points and took the correlations for all of the x and y points. The y points had a correlation of ~80% and the x points had a lower correlation of ~40%. 

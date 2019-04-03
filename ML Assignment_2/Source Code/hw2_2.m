% Closed Form Linear Regression
clc;
clear;

% Reads the data, ignoring the ﬁrst row (header) and ﬁrst column (index)
filename = 'x06Simple.csv';
X = csvread(filename, 1, 1);
e = size(X,2);
X(:, end) = [];
Y = csvread(filename, 1, e, [1, e, size(X, 1), e]);

% Randomizes the data
rng(0); % Seed the random number
colLen = size(X, 1);
R = randperm(colLen);

for i=1:colLen
    Xrand(i, :) = X(R(i), 1:end);
    Yrand(i, :) = Y(R(i), 1:end);
end

% Selects the ﬁrst 2/3(round up) data for training and the remaining for testing
t = ceil(colLen*2/3);

Xtrain = Xrand(1:t, :);
Ytrain = Yrand(1:t, :);

Xtest = Xrand(t+1:end, :);
Ytest = Yrand(t+1:end, :);

% Standardizes the data using the training data
m = mean(Xtrain); s = std(Xtrain);
Xtrain = (Xtrain - m)./s;
Xtrain = [ones(size(Xtrain,1), 1) Xtrain]; % Add in the bias feature

% Computes the closed-form solution of linear regression
weight = (inv(Xtrain' * Xtrain) * Xtrain') * Ytrain

% Applies the solution to the testing samples
Xtest = (Xtest - m)./s;
Xtest = [ones(size(Xtest,1), 1) Xtest]; % Add in the bias feature
Y_hat = Xtest * weight;

% Computes the root mean squared error (RMSE)
N = size(Xtest,1);
MSE = (1/N)*sum((Ytest - Y_hat).^2);
RMSE = sqrt(MSE)

% Locally-Weighted Linear Regression
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
Xtest = (Xtest - m)./s;
Xtest = [ones(size(Xtest,1), 1) Xtest]; % Add in the bias feature

% Let k = 1 in the similarity function
k = 1;
Y_hat = []; sqEr = [];

for i =1:size(Xtest, 1) % For each testing sample
    Beta = [];
    
    %For Each Training Sample, calculate e^(-d(a,b)/k^2)
    for j =1:size(Xtrain, 1)
        % Use the L1 distance when computing the distances
        Beta = [Beta; exp((-sum(abs(Xtest(i,:)-Xtrain(j,:)))) / (k^2))];
    end
    
    W = diag(Beta);
    
    %Calculate the weight
    weight = (inv(Xtrain' * W * Xtrain)) * Xtrain' * W * Ytrain;

    Y_hat = [Y_hat; (Xtest(i, :)*weight)];
    % Compute the squared error of the testing sample
    sqEr = [sqEr; (Ytest(i,:) - (Xtest(i, :)*weight))^2];
end

% Compute the RMSE
N = size(Ytest, 1);
RMSE = sqrt((1/N)*(sum(sqEr)))

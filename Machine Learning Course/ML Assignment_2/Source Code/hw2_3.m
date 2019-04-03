% S-Folds Cross-Validation
clc;
clear;

% Reads in the data, ignoring the ﬁrst row (header) and ﬁrst column (index)
filename = 'x06Simple.csv';

X = csvread(filename, 1, 1);
e = size(X,2);
X(:, end) = [];
Y = csvread(filename, 1, e, [1, e, size(X, 1), e]);

allRMSE = []; % Store the 20 RMSE values

rng(0); % Seed the random number

for j = 1:20
    
    % Randomizes the data
    colLen = size(X, 1);
    R = randperm(colLen);
    for i=1:colLen
        Xrand(i, :) = X(R(i), 1:end);
        Yrand(i, :) = Y(R(i), 1:end);
    end
    
    % Creates S folds
    S = 5; % Set any number of folders(S = 3,5,20,N)
    foldSize = floor(size(Xrand, 1)/S);
    
    SE =[]; % Store the N square error
    
    for i = 1:S
   
        % The fold i as testing data 
        startIdx = ((i-1)*foldSize)+1; 
        endIdx = startIdx+foldSize-1;
        testIdx = startIdx : endIdx;
        if i == S
            testIdx = startIdx : size(Xrand, 1);
        end
        
        % The remaining (S−1) folds as training data
        trainIdx = setdiff(1:size(Xrand,1), testIdx);
        
        Xtrain = Xrand(trainIdx, :);
        Ytrain = Yrand(trainIdx, :);
    
        Xtest = Xrand(testIdx, :);
        Ytest = Yrand(testIdx, :);

        % Standardizes the training data
        m = mean(Xtrain); s = std(Xtrain);
        Xtrain = (Xtrain - m)./s;

        Xtrain = [ones(size(Xtrain,1), 1) Xtrain]; % Add in the bias feature

        % Train a closed-form linear regression model
        weight = (inv(Xtrain' * Xtrain) * Xtrain') * Ytrain;

        % Standardize Test Data using m and s
        Xtest = (Xtest - m)./s;

        Xtest = [ones(size(Xtest,1), 1) Xtest]; % Add in the bias feature

        % Compute the squared error for each sample in the current testing fold
        Y_hat = Xtest * weight;
        SE = [SE; ((Ytest - Y_hat).^2)]; % Store the N square error
    
    end

    % Compute the RMSE using all square errors
    allRMSE = [allRMSE; sqrt((1/size(SE,1)) * sum(SE))];

end

% Now we have 20 RMSE values stored in allRMSE
% Compute the mean and standard deviation
allM = mean(allRMSE)
allS = std(allRMSE)
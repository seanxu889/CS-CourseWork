%% Gradient Descent
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

% Initialize the parameters of θ using random values in the range [-1, 1]
rng(0);
n = size(Xtrain, 2);
thetaRand = rand(n, 1)*2-1;

% Set the hyperparameters
iter = 10000; % iterations 1,000,000
lR = 0.01; % learning rate
cond = true;
num = 1;
RMSE_train = [];
RMSE_test = [];

% Number of observations
Ntrain = size(Xtrain, 1);
Ntest = size(Xtest, 1);

% While the termination criteria hasn’t been met
% Do full batch gradient descent
while cond && (num<iter)
   
    % Compute gradient
    G = Xtrain' * (Xtrain * thetaRand - Ytrain); 
    % Update theta
    thetaRand = thetaRand - ((lR/Ntrain) *  G);  
       
    % Compute the RMSE of the training and testing data    
    MSE_train = (1/Ntrain)*(sum((Ytrain - Xtrain * thetaRand).^2) );
    RMSE_train = [RMSE_train sqrt(MSE_train)];
    
    MSE_test= (1/Ntest)*(sum((Ytest - Xtest * thetaRand).^2) );
    RMSE_test = [RMSE_test sqrt(MSE_test)];
    
    % RMSE of the last iteration
    if num>1
        lastRMSE = RMSE_train(end-1);
        % Check the termination criteria
        percentChange = abs(thetaRand - lastRMSE) / lastRMSE;
    end
    
    % Set cond to False if percent change less than 2^-23
    if (num>1 & percentChange<2^-23)
        cond = false;
    end

    num = num+1;
end

%% Plot and show the final results

% The RMSE of training and testing data
RMSE_train_final = RMSE_train(end);
RMSE_test_final = RMSE_test(end);

% Print the results
disp('Theta:'); disp(thetaRand);
disp('Final RMSE testing error:'); disp(RMSE_test_final);
disp('Final RMSE training error:'); disp(RMSE_train_final);

% Plot the RMSE as a function of the iteration
figure(1);
plot(1:(num-1), RMSE_train, 'r');
hold on;
plot(1:(num-1), RMSE_test, 'b');
hold off;
xlabel('Iteration');
ylabel('RMSE');
legend('Training Error', 'Testing Error');
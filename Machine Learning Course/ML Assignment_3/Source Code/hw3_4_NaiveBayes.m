% Naive Bayes Classiﬁer 
clc;
clear;

%% Date processing
% Reads the data
filename = 'CTG.csv';
D = importdata(filename);
data = D.data(2:end,:);
X = data(:,1:(end-2));
Y = data(:,end);
F = D.textdata(1:end-2);

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
Xtrain_sta = (Xtrain - m)./s;
Xtest_sta = (Xtest - m)./s;

% Divides the training data into C1,C2 and C3 samples
Xtrain_sta_C1 = Xtrain_sta(find(Ytrain==1), :);
Xtrain_sta_C2 = Xtrain_sta(find(Ytrain==2), :);
Xtrain_sta_C3 = Xtrain_sta(find(Ytrain==3), :);

%% Creates Normal models for each feature for each class
% Priors
Prior_Xtrain_C1 = size(Xtrain_sta_C1, 1)/(size(Xtrain_sta, 1));
Prior_Xtrain_C2 = size(Xtrain_sta_C2, 1)/(size(Xtrain_sta, 1));
Prior_Xtrain_C3 = size(Xtrain_sta_C3, 1)/(size(Xtrain_sta, 1));

% Gaussian Distribution
m_Xtrain_C1 = mean(Xtrain_sta_C1); s_Xtrain_C1 = std(Xtrain_sta_C1);
m_Xtrain_C2 = mean(Xtrain_sta_C2); s_Xtrain_C2 = std(Xtrain_sta_C2);
m_Xtrain_C3 = mean(Xtrain_sta_C3); s_Xtrain_C3 = std(Xtrain_sta_C3);

GD_C1 = normpdf(Xtest_sta, m_Xtrain_C1, s_Xtrain_C1);
GD_C2 = normpdf(Xtest_sta, m_Xtrain_C2, s_Xtrain_C2);
GD_C3 = normpdf(Xtest_sta, m_Xtrain_C3, s_Xtrain_C3);

% Calculate the Naive Bayes probability
prob_C1 = prod(GD_C1, 2);
prob_C2 = prod(GD_C2, 2);
prob_C3 = prod(GD_C3, 2);

post_Ytest_hat_C1 = (Prior_Xtrain_C1 .* prob_C1);
post_Ytest_hat_C2 = (Prior_Xtrain_C2 .* prob_C2);
post_Ytest_hat_C3 = (Prior_Xtrain_C3 .* prob_C3);

%% Classify each testing sample
% and choosing the class label based on which class probability is higher
Ytest_hat = zeros(size(Ytest, 1), 1);
for i =1:size(Ytest, 1)
    if (post_Ytest_hat_C1(i) == max(max(post_Ytest_hat_C1(i),post_Ytest_hat_C2(i)),post_Ytest_hat_C3(i)))
        Ytest_hat(i) = 1;
    elseif (post_Ytest_hat_C2(i) == max(max(post_Ytest_hat_C1(i),post_Ytest_hat_C2(i)),post_Ytest_hat_C3(i)))
        Ytest_hat(i) = 2;
    elseif (post_Ytest_hat_C3(i) == max(max(post_Ytest_hat_C1(i),post_Ytest_hat_C2(i)),post_Ytest_hat_C3(i)))
        Ytest_hat(i) = 3;
    end
end

%% Computes the Naive Bayes accuracy
CorrectNum = 0;
for i =1:size(Ytest, 1)
    if(Ytest_hat(i) == Ytest(i))
        CorrectNum = CorrectNum+1;
    end
end

accuracy = CorrectNum / size(Ytest,1);

% Print the accuracy
fprintf('The testing accuracy of Naive Bayes (Multi-class) classifier: ');
fprintf('Accuracy = %f\n',accuracy);
% Naive Bayes Classiﬁer 
clc;
clear;

%% Date processing
% Reads the data
filename = 'spambase.data';
X = importdata(filename);
Y = X(:, size(X, 2));
X(:, end) = [];

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
Xtest_standardize = (Xtest - m)./s;

% Divides the training data into Spam & Non-Spam samples
XtrainSpam = Xtrain(find(Ytrain==1), :);
XtrainNot = Xtrain(find(Ytrain==0), :);

%% Creates Normal models for each feature for each class
% Priors
Prior_XtrainSpam = size(XtrainSpam, 1)/(size(Xtrain, 1));
Prior_XtrainNot = size(XtrainNot, 1)/(size(Xtrain, 1));

% Gaussian Distribution
m_XtrainSpam = mean(XtrainSpam); s_XtrainSpam = std(XtrainSpam);
m_XtrainNot = mean(XtrainNot); s_XtrainNot = std(XtrainNot);
GDSpam = normpdf(Xtest_standardize, m_XtrainSpam, s_XtrainSpam);
GDNot = normpdf(Xtest_standardize, m_XtrainNot, s_XtrainNot);

% Calculate the Naive Bayes probability
probSpam = prod(GDSpam, 2);
probNot = prod(GDNot, 2);

post_Ytest_hat_Spam = (Prior_XtrainSpam .* probSpam);
post_Ytest_hat_Not = (Prior_XtrainNot .* probNot);

%% Classify each testing sample
% and choosing the class label based on which class probability is higher
Ytest_hat = zeros(size(Ytest, 1), 1);
for i =1:size(Ytest, 1)
    if(post_Ytest_hat_Spam(i) > post_Ytest_hat_Not(i))
        Ytest_hat(i) = 1;
    else
        Ytest_hat(i) = 0;
    end
end

%% Computes the statistics using the testing data results
label = [];
for i =1:size(Ytest, 1)   
    if(Ytest_hat(i)== 1 && Ytest_hat(i) == Ytest(i))
        label = [label; 'A'];
    elseif(Ytest_hat(i) == 0 && Ytest_hat(i) == Ytest(i))
        label = [label; 'B'];
    elseif(Ytest_hat(i) == 1 && Ytest_hat(i) ~= Ytest(i))
        label = [label; 'C'];  
    elseif(Ytest_hat(i) == 0 && Ytest_hat(i) ~= Ytest(i))
        label = [label; 'D'];     
    end
end

TP_num = sum(label=='A');
TN_num = sum(label=='B');
FP_num = sum(label=='C');
FN_num = sum(label=='D');

% Compute: Precision, Recall, F-measure, Accuracy
precision = TP_num/(TP_num+FP_num);
recall = TP_num/(TP_num+FN_num);
f_measure = (2*precision*recall) / (precision+recall);
accuracy = (TP_num+TN_num) / (TP_num+TN_num+FP_num+FN_num);

% Print the results
fprintf('Precision = %f\n',precision);
fprintf('Recall = %f\n',recall);
fprintf('F-measure = %f\n',f_measure);
fprintf('Accuracy = %f\n',accuracy);

% Decision Trees
clc;
clear;

%% Data processing
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
Xtrain_standardize = (Xtrain - m)./s;
Xtest_standardize = (Xtest - m)./s;

% Divides the training data into Spam & Non-Spam samples
XtrainSpam = Xtrain_standardize(find(Ytrain==1), :);
XtrainNot = Xtrain_standardize(find(Ytrain==0), :);

% Pre-processing the training data to 0/1
Xtrain_sta_bin = zeros(size(Xtrain_standardize,1),size(Xtrain_standardize,2));
for i = 1:size(Xtrain_standardize,1)
    for j = 1:size(Xtrain_standardize,2)
        if Xtrain_standardize(i,j)>0
            Xtrain_sta_bin(i,j)=1;
        else
            Xtrain_sta_bin(i,j)=0;
        end
    end
end

matrix = [Xtrain_sta_bin, Ytrain]; %(1,57+1)
features = cell(1,size(matrix,2)); %{1,58}
for i = 1:size(matrix,2)
    features{i} = ['f_',num2str(i)]; %feature_1,feature_2,...,feature_57
end
activeFeatures = ones(1,size(Xtrain_sta_bin,2));

%% Train the decision tree using the ID3 algorithm
tree = id3Tree(matrix,features,activeFeatures);

%% Classify each testing sample using your trained decision tree
% Pre-processing the testing data to 0/1
Xtest_sta_bin = zeros(size(Xtest_standardize,1),size(Xtest_standardize,2));
for i = 1:size(Xtest_standardize,1)
    for j = 1:size(Xtest_standardize,2)
        if Xtest_standardize(i,j)>0
            Xtest_sta_bin(i,j)=1;
        else
            Xtest_sta_bin(i,j)=0;
        end
    end
end
matrixTest = [Xtest_sta_bin,Ytest]; classifyLabel = [];
for k = 1:size(matrixTest,1)
    Label = id3TreeClassify(tree,matrixTest(k,:),features);
    classifyLabel = [classifyLabel;Label];
end

%% Computes the statistics using the testing data results
Ytest_hat = classifyLabel(:,1);
label = [];
for i =1:size(Ytest, 1)
    if (Ytest_hat(i)== 1 && Ytest_hat(i) == Ytest(i))
        label = [label; 'A'];
    elseif (Ytest_hat(i) == 0 && Ytest_hat(i) == Ytest(i))
        label = [label; 'B'];
    elseif (Ytest_hat(i) == 1 && Ytest_hat(i) ~= Ytest(i))
        label = [label; 'C'];  
    elseif (Ytest_hat(i) == 0 && Ytest_hat(i) ~= Ytest(i))
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

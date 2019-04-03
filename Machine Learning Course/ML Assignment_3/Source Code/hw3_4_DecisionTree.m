% Evaluate the two classiﬁers (Naive Bayes and Decision Trees) on a multi-class dataset
%{
The scripts must be able to run on any dataset where the ﬁrst two rows 
contain header information, the 2nd to last column is to be discarded, 
and the last column contains the target class.
%}

clc;
clear;

%% Data processing
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

% Pre-processing the training data to 0/1
Xtrain_sta_bin = zeros(size(Xtrain_sta,1),size(Xtrain_sta,2));
for i = 1:size(Xtrain_sta,1)
    for j = 1:size(Xtrain_sta,2)
        if Xtrain_sta(i,j)>0
            Xtrain_sta_bin(i,j)=1;
        else
            Xtrain_sta_bin(i,j)=0;
        end
    end
end

matrix = [Xtrain_sta_bin, Ytrain];
features = F;
activeFeatures = ones(1,size(Xtrain_sta_bin,2));

%% Train the decision tree using the ID3 algorithm
tree_multi = id3Tree_multi(matrix,features,activeFeatures);
 
%% Classify each testing sample using your trained decision tree (multi-class)
% Pre-processing the testing data to 0/1
Xtest_sta_bin = zeros(size(Xtest_sta,1),size(Xtest_sta,2));
for i = 1:size(Xtest_sta,1)
    for j = 1:size(Xtest_sta,2)
        if Xtest_sta(i,j)>0
            Xtest_sta_bin(i,j)=1;
        else
            Xtest_sta_bin(i,j)=0;
        end
    end
end
matrixTest = [Xtest_sta_bin,Ytest]; classifyLabel = [];
for k = 1:size(matrixTest,1)
    Label = id3TreeClassify_multi(tree_multi,matrixTest(k,:),features);
    classifyLabel = [classifyLabel; Label];
end

%% Computes the ID3 Decision Tree accuracy 
Ytest_hat = classifyLabel(:,1);
CorrectNum = 0;
for i =1:size(Ytest, 1)
    if(Ytest_hat(i) == Ytest(i))
        CorrectNum = CorrectNum+1;
    end
end

accuracy = CorrectNum / size(classifyLabel,1);

% Print the accuracy
fprintf('The testing accuracy of ID3 Decision Tree (Multi-class) classifier: ');
fprintf('Accuracy = %f\n',accuracy);
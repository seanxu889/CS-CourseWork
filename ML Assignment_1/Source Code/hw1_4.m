%% 4.Clustering:

% 1).Pre-process the data
dataMatrix = [];
d = dir('yalefaces/subject*');
for i=1:154
    path = ['yalefaces/' d(i).name];
    pic = imread(path);     
    picSub = imresize(pic, [40,40]);
    picSubLine = reshape(picSub, [1,1600]);
    dataMatrix = [dataMatrix; picSubLine];
end
dm3 = double(dataMatrix);

% 2).Standardizes the data
meanPic = mean(dm3);
stdPic = std(dm3);
dm3 = dm3 - repmat(meanPic,size(dm3,1),1);
dm3 = dm3./repmat(stdPic,size(dm3,1),1);
X = dm3;

% 3).Call the main function
% Passes the data(X) and the number of clusters(k) to 'myKMeans' function
myKMeans(X,2);
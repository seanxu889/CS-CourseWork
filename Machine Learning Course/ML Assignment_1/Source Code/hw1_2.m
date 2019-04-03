%% 2.Dimensionality Reduction via PCA:

% 1).Read data
dataMatrix = [];
d = dir('yalefaces/subject*')
for i=1:154
    path = ['yalefaces/' d(i).name];
    pic = imread(path);     
    picSub = imresize(pic, [40,40]);
    picSubLine = reshape(picSub, [1,1600]);
    dataMatrix = [dataMatrix; picSubLine];
end
dm = double(dataMatrix);

% 2).Standardizes the data
meanPic = mean(dm);
stdPic = std(dm);
dm = dm - repmat(meanPic,size(dm,1),1);
dm = dm./repmat(stdPic,size(dm,1),1);

% 3).Reduces the data to 2D using PCA, k=2
[vec,val] = eigs(cov(dm),2);
W = vec;
Z = dm * W;

% 4).Graphs the data for visualization
plot(Z(:,1),Z(:,2),'bo'), title('2D PCA Projection of data')

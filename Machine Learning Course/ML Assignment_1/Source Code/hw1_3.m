%% 3.Eigenfaces:

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
dm2 = double(dataMatrix); keepData = dm2;

% 2).Standardizes the data
meanPic = mean(dm2);
stdPic = std(dm2);
dm2 = dm2 - repmat(meanPic,size(dm2,1),1);
dm2 = dm2./repmat(stdPic,size(dm2,1),1);

% 3).Performs PCA
% 4).Determines the number of principle components
[vec,val] = eig(cov(dm2));
vals = diag(val);
valsSum = sum(vals);
sumTemp = 0; p = 1601;
while (sumTemp/valsSum<0.95)
    p = p-1;
    sumTemp = sum(vals(p:end));
end
k = 1601 - p
[vec_k,val_k] = eigs(cov(dm2),k);
% Normalized to be unit length
colSum = sum(vec_k);
diagNor = diag(colSum);
vec_kNor = vec_k*(diagNor^-1);
Z2 = dm2 * vec_kNor;

% 5).Visualizes the most important principle component as a 40x40 image
vec_Best = vec_kNor(:,1);
visImg = reshape(vec_Best,[40,40]);
figure(1);imagesc(visImg);colormap('gray');

% 6).Reconstructs the ﬁrst person
% Visualization of the reconstruction using original image
figure(2);
imagesc(reshape(keepData(1,:),[40,40])),title('Original image');colormap('gray');
% Visualization of the reconstruction using single principle component
figure(3);
subplot(1,2,1);imagesc(visImg),title('Single principle component');colormap('gray');
% Visualization of the reconstruction using k principle components
dm2Recon = Z2(1,:) * vec_k';
visImgk = reshape(dm2Recon,[40,40]);
subplot(1,2,2);imagesc(visImgk),title('K principle components');colormap('gray');

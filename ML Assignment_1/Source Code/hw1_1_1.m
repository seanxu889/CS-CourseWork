%% 1.Theory Questions 1:

% (a) Find the principle components of the data
% Standardize the data
X = [-2,1; -5,-4; -3,1; 0,3; -8,11; -2,5; 1,0; 5,-1; -1,-3; 6,1];
% Get mean of each feature
m = [(-2-5-3+0-8-2+1+5-1+6)/10, (1-4+1+3+11+5+0-1-3+1)/10]
% Get std of each feature
s = [(((-2+0.9)^2+(-5+0.9)^2+(-3+0.9)^2+(0+0.9)^2+(-8+0.9)^2+(-2+0.9)^2+...
    (1+0.9)^2+(5+0.9)^2+(-1+0.9)^2+(6+0.9)^2)/9)^0.5 , ...
    (((1-1.4)^2+(-4-1.4)^2+(1-1.4)^2+(3-1.4)^2+(11-1.4)^2+(5-1.4)^2+...
    (0-1.4)^2+(-1-1.4)^2+(-3-1.4)^2+(1-1.4)^2)/9)^0.5] 
% Subtract the means from each observation
X = X - repmat(m,size(X,1),1);
% Divide each (centered) observation by the standard deviation
X = X./repmat(s,size(X,1),1)

% Compute covariance matrix
% Because the data's columns have zero mean, then we can compute the
% covariance matrix by (X_t*X)/(N-1).
cm11 = 1;
cm12 = ((-0.2602*-0.0936)+(-0.9697*-1.2635)+(-0.4967*-0.0936)+0.2129*0.3744+...
    (-1.6792*2.2462)+(-0.2602*0.8423)+0.4494*-0.3276+1.3954*-0.5615+(-0.0237*-1.0295)+1.6319*-0.0936)/9;
cm21 = ((-0.0936*-0.2602)+(-1.2635*-0.9697)+(-0.0936*-0.4967)+0.3744*0.2129+...
    (2.2462*-1.6792)+(0.8423*-0.2602)+(-0.3276*0.4494)+(-0.5615*1.3954)+(-1.0295*-0.0237)+(-0.0936*1.6319))/9;
cm22 = 1;
convmat = [cm11,cm12; cm21,cm22]

% Compute eigenvalues and eigenvectors of convmat and normalized to unit length
lamb1 = (2-(1-4*1*0.83329111)^0.5)/2; % lamb1 = 1+0.4083 = 0.5917
lamb2 = (2+(1-4*1*0.83329111)^0.5)/2; % lamb2 = 1-0.4083 = 1.4083
% Find the eigenvectors
% Solve [[1 -0.4083;-0.4083 1]-[0.5917 0; 0 0.5917]]*[x; y] = [0; 0], we get x=y  
% Solve [[1 -0.4083;-0.4083 1]-[1.4083 0; 0 1.4083]]*[x; y] = [0; 0], we get x=-y
val = [0.5917 0; 0 1.4083] % eigenvalues are on the diagonal of val
vec = [-0.7071 -0.7071; -0.7071 0.7071] % eigenvectors are the columns of vec

% (b) Project the data
% Because max(0.5917,1.4083) = 1.4083, so we choose the second eigenvector:
V = [-0.7071; 0.7071]
% Project the points onto the vector V
Z = X * V

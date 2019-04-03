%% 1.Theory Questions 2:

% (a) Compute the information gain for each feature
% Class 1 samples: 
C1 = [-2,1; -5,-4; -3,1; 0,3; -8,11];
% Class 2 samples:
C2 = [-2,5; 1,0; 5,-1; -1,-3; 6,1];
% Feature 1:
p1n8 = 1; n1n8 = 0;
p1n5 = 1; n1n5 = 0;
p1n3 = 1; n1n3 = 0;
p1n2 = 1; n1n2 = 1;
p1n1 = 0; n1n1 = 1;
p1p0 = 1; n1p0 = 0;
p1p1 = 0; n1p1 = 1;
p1p5 = 0; n1p5 = 1;
p1p6 = 0; n1p6 = 1;
E_H1 = 1/10*(-1*log2(1))+1/10*(-1*log2(1))+1/10*(-1*log2(1))+...
    2/10*(-1/2*log2(1/2)-1/2*log2(1/2))+1/10*(-1*log2(1))+...
    1/10*(-1*log2(1))+1/10*(-1*log2(1))+1/10*(-1*log2(1))+1/10*(-1*log2(1)) 
IG_1 = 1-E_H1 % E_H1=0.2,IG_1=0.8
% Feature 2:
p1n4 = 1; n1n4 = 0;
p1n3 = 0; n1n3 = 1;
p1n1 = 0; n1n1 = 1;
p1p0 = 0; n1p0 = 1;
p1p1 = 2; n1p1 = 1;
p1p3 = 1; n1p3 = 0;
p1p5 = 0; n1p5 = 1;
p1p11 = 1; n1p11 = 0;
E_H2 = 1/10*(-1*log2(1))+1/10*(-1*log2(1))+1/10*(-1*log2(1))+...
    1/10*(-1*log2(1))+3/10*(-2/3*log2(2/3)-1/3*log2(1/3))+...
    1/10*(-1*log2(1))+1/10*(-1*log2(1))
IG_2 = 1-E_H2 % E_H2=0.2755,IG_2=0.7245

% (b) Which feature is more discriminating based on results in part a
% Because IG_1 > IG_2, so feature 1 is more discriminating.

% (c) Using LDA, ﬁnd the direction of projection. Normalize this vector to be unit length
% Get mean of each feature for each classes
m_c1 = [(-2-5-3+0-8)/5, (1-4+1+3+11)/5];
m_c2 = [(-2+1+5-1+6)/5, (5+0-1-3+1)/5];

% Compute covariance matrix
convmat_c1 = [9.3 -7.45; -7.45 29.8];
convmat_c2 = [12.7 -2.4; -2.4 8.8];

% Compute the scatter matrices
sm_c1 = (5-1)*convmat_c1
sm_c2 = (5-1)*convmat_c2
Sw = sm_c1^2 + sm_c2^2;
Sb = (m_c1 - m_c2)' * (m_c1 - m_c2);
% Perform eigen-decomposition on inv(Sw) * Sb:(the columns of V_2 is the eigenvectors)
[V_2,D_2] = eig(inv(Sw) * Sb);
% The eigenvector pertaining to the only noneigenvalue is our projection matrix
% So the direction of projection:
w = [0.9692; 0.2461]

% (d) Project the data
Z1 = C1 * w
Z2 = C2 * w

% (e) Does the projection seem to provide good class sepa-ration? Why or why not？
% It performas not bad. In Class1, 4 out of the 5 points are on the negative scale,
% and in Class2, 3 out of the 5 points are on the positive scale. 
% However, the point 0.7383 in Class1 and the points -0.7079 & -1.7075 are mixed.
% Hence, I think the data cannot be clearly separable in this method and we could do better.

function [tree] = id3Tree(matrix, features, activeFeatures)
% Training a decision tree using the ID3 algorithm

%% Construct the tree
numberFeatures = length(activeFeatures); 
numberExamples = length(matrix(:,1)); 

% Create a tree node
tree = struct('value', 'null', 'left', 'null', 'right', 'null');

lastColumnSum = sum(matrix(:, numberFeatures + 1));
% Returns "true" if the last column is all 1
if (lastColumnSum == numberExamples)
    tree.value = 'true';
    return
end
% Returns "false" if the last column is all 0
if (lastColumnSum == 0)
    tree.value = 'false';
    return
end

% If the active feature is empty, Returns the value of the feature with the most labels
if (sum(activeFeatures) == 0)
    if (lastColumnSum >= numberExamples / 2)
        tree.value = 'true';
    else
        tree.value = 'false';
    end
    return
end

%% Calculate the entropy of the current feature
p1 = lastColumnSum / numberExamples; 
if (p1 == 0)
    p1_eq = 0;
else
    p1_eq = -1*p1*log2(p1);
end
p0 = (numberExamples - lastColumnSum) / numberExamples;
if (p0 == 0)
    p0_eq = 0;
else
    p0_eq = -1*p0*log2(p0);
end
IEtotal = p1_eq + p0_eq; 

%% Finding the max gain
gains = -1*ones(1,numberFeatures); % Initial gain matrix

for i=1:numberFeatures
    if (activeFeatures(i) == 1) 
        s0 = 0; s0_and_true = 0;
        s1 = 0; s1_and_true = 0;
        for j=1:numberExamples
            if (matrix(j,i) == 1)
                s1 = s1 + 1;
                if (matrix(j, numberFeatures + 1) == 1)
                    s1_and_true = s1_and_true + 1;
                end
            else
                s0 = s0 + 1;
                if (matrix(j, numberFeatures + 1) == 1) 
                    s0_and_true = s0_and_true + 1;
                end
            end
        end

        % Entropy S(v=1)
        if (s1 == 0)
            p1 = 0;
        else
            p1 = (s1_and_true / s1); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (s1 == 0)
            p0 = 0;
        else
            p0 = ((s1 - s1_and_true) / s1);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s1 = p1_eq + p0_eq;

        % Entropy S(v=0)
        if (s0 == 0)
            p1 = 0;
        else
            p1 = (s0_and_true / s0); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (s0 == 0)
            p0 = 0;
        else
            p0 = ((s0 - s0_and_true) / s0);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s0 = p1_eq + p0_eq;

        gains(i) = IEtotal - (((s1/numberExamples)*entropy_s1) + ((s0/numberExamples)*entropy_s0));
    end
end

% Choose the maximum gain
[~, bestFeature] = max(gains);
tree.value = features{bestFeature};
% Remove the active state
activeFeatures(bestFeature) = 0;

% Group the data based on best feature
matrix_0= matrix(matrix(:,bestFeature)==0,:);
matrix_1= matrix(matrix(:,bestFeature)==1,:);

% When value = false or 0, left branch
if (isempty(matrix_0) == 1)
    leaf = struct('value', 'null', 'left', 'null', 'right', 'null');
    if (lastColumnSum >= numberExamples/2)
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.left = leaf;
else
    % Recursion to construct the tree
    tree.left = id3Tree(matrix_0, features, activeFeatures);
end
% When value = true or 1, right branch
if (isempty(matrix_1) == 1)
    leaf = struct('value', 'null', 'left', 'null', 'right', 'null');
    if (lastColumnSum >= numberExamples/2)
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.right = leaf;
else
    % Recursion to construct the tree
    tree.right = id3Tree(matrix_1, features, activeFeatures);
end

return
end

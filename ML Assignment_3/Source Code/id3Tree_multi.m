% Training a decision tree using the ID3 algorithm
function [tree] = id3Tree_multi(matrix, features, activeFeatures)

%% Construct the tree
numberFeatures = length(activeFeatures); %21
numberExamples = length(matrix(:,1)); %1418

% Create a tree node
tree = struct('value', 'null', 'left', 'null', 'right', 'null');

lastColumnSum = sum(matrix(:, numberFeatures+1)); %1+2+3+1+1+3+2+1+2+2...
% Returns "C1" if the last column is all 1
if (lastColumnSum == numberExamples)
    tree.value = 'C1';
    return
end
% Returns "C2" if the last column is all 2
if (lastColumnSum == 2*numberExamples)
    tree.value = 'C2';
    return
end
% Returns "C3" if the last column is all 3
if (lastColumnSum == 3*numberExamples)
    tree.value = 'C3';
    return
end

% If the active feature is empty, Returns the value of the feature with the most labels
count1 = sum(matrix(:,end)==1);
count2 = sum(matrix(:,end)==2);
count3 = sum(matrix(:,end)==3);
if (sum(activeFeatures) == 0)
    if (count1 == max(max(count1,count2),count3))
        tree.value = 'C1';
    end
    if (count2 == max(max(count1,count2),count3))
        tree.value = 'C2';
    end
    if (count3 == max(max(count1,count2),count3))
        tree.value = 'C3';
    end
    return
end

%% Calculate the entropy of the current feature
p1 = sum(matrix(find(matrix(:,end)==1),end)) / numberExamples;        
if (p1 == 0)
    p1_eq = 0;
else
    p1_eq = -1*p1*log2(p1);
end
p2 = (sum(matrix(find(matrix(:,end)==2),end))/2) / numberExamples;
if (p2 == 0)
    p2_eq = 0;
else
    p2_eq = -1*p2*log2(p2);
end
p3 = (sum(matrix(find(matrix(:,end)==3),end))/3) / numberExamples;
if (p3 == 0)
    p3_eq = 0;
else
    p3_eq = -1*p3*log2(p3);
end
IEtotal = p1_eq + p2_eq + p3_eq; 

%% Finding the max gain
gains = -1*ones(1,numberFeatures); % Initial gain matrix #21

for i=1:numberFeatures %21
    if (activeFeatures(i) == 1) 
        s1 = 0; s1_and_1 = 0; s1_and_2 = 0; s1_and_3 = 0;
        s0 = 0; s0_and_1 = 0; s0_and_2 = 0; s0_and_3 = 0;
        
        for j=1:numberExamples
            if (matrix(j,i) == 1)
                s1 = s1 + 1;
                if (matrix(j, numberFeatures + 1) == 1)
                    s1_and_1 = s1_and_1 + 1;
                elseif (matrix(j, numberFeatures + 1) == 2)
                    s1_and_2 = s1_and_2 + 1;
                elseif (matrix(j, numberFeatures + 1) == 3)
                    s1_and_3 = s1_and_3 + 1;
                end
            else
                s0 = s0 + 1;
                if (matrix(j, numberFeatures + 1) == 1)
                    s0_and_1 = s0_and_1 + 1;
                elseif (matrix(j, numberFeatures + 1) == 2)
                    s0_and_2 = s0_and_2 + 1;
                elseif (matrix(j, numberFeatures + 1) == 3)
                    s0_and_3 = s0_and_3 + 1;
                end
            end              
        end

        % Entropy S 1
        if (s1 == 0)
            p1 = 0;
        else
            p1 = (s1_and_1 / s1); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        
        if (s1 == 0)
            p2 = 0;
        else
            p2 = ((s1_and_2) / s1);
        end
        if (p2 == 0)
            p2_eq = 0;
        else
            p2_eq = -1*(p2)*log2(p2);
        end
        
        if (s1 == 0)
            p3 = 0;
        else
            p3 = ((s1_and_3) / s1);
        end
        if (p3 == 0)
            p3_eq = 0;
        else
            p3_eq = -1*(p3)*log2(p3);
        end
        
        entropy_s1 = p1_eq + p2_eq + p3_eq;

        % Entropy S 0
        if (s0 == 0)
            p1 = 0;
        else
            p1 = (s0_and_1 / s0); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        
        if (s0 == 0)
            p2 = 0;
        else
            p2 = ((s0_and_2) / s0);
        end
        if (p2 == 0)
            p2_eq = 0;
        else
            p2_eq = -1*(p2)*log2(p2);
        end
        
        if (s0 == 0)
            p3 = 0;
        else
            p3 = ((s0_and_3) / s0);
        end
        if (p3 == 0)
            p3_eq = 0;
        else
            p3_eq = -1*(p3)*log2(p3);
        end
        
        entropy_s0 = p1_eq + p2_eq + p3_eq;

        gains(i) = IEtotal - (((s1/numberExamples)*entropy_s1) + ((s0/numberExamples)*entropy_s0));
    end
end

% Choose the maximum gain
[~, bestFeatures] = max(gains);
tree.value = features{bestFeatures};
% Remove active state
activeFeatures(bestFeatures) = 0;

% Group the data based on best features
matrix_0= matrix(matrix(:,bestFeatures)==0,:);
matrix_1= matrix(matrix(:,bestFeatures)==1,:);

% When value = false or 0, left branch
if (isempty(matrix_0) == 1)
    leaf = struct('value', 'null', 'left', 'null', 'right', 'null');
    if (count1 == max(max(count1,count2),count3))
        leaf.value = 'C1';
    end
    if (count2 == max(max(count1,count2),count3))
        leaf.value = 'C2';
    end
    if (count3 == max(max(count1,count2),count3))
        leaf.value = 'C3';
    end
    tree.left = leaf;
else
    % Recursion to construct the tree
    tree.left = id3Tree_multi(matrix_0, features, activeFeatures);
end
% When value = true or 1, right branch
if (isempty(matrix_1) == 1)
    leaf = struct('value', 'null', 'left', 'null', 'right', 'null');
    if (count1 == max(max(count1,count2),count3))
        leaf.value = 'C1';
    end
    if (count2 == max(max(count1,count2),count3))
        leaf.value = 'C2';
    end
    if (count3 == max(max(count1,count2),count3))
        leaf.value = 'C3';
    end
    tree.right = leaf;
else
    % Recursion to construct the tree
    tree.right = id3Tree_multi(matrix_1, features, activeFeatures);
end

return
end

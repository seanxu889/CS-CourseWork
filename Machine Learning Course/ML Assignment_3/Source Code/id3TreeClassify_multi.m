function [classifications] = id3TreeClassify_multi(tree, totalData, features)

% Store the actual classification
actual = totalData(1, size(totalData,2));

% Recursion with three cases
% Case 1: Current node is labeled 'C1'
if (strcmp(tree.value, 'C1') == 1)
    classifications = [1, actual];
    return
end

% Case 2: Current node is labeled 'C2'
if (strcmp(tree.value, 'C2') == 1)
    classifications = [2, actual];
    return
end

% Case 3: Current node is labeled 'C3'
if (strcmp(tree.value, 'C3') == 1)
    classifications = [3, actual];
    return
end

% Case 4: Current node is labeled as an attribute
index = find(ismember(features,tree.value) == 1);
if (totalData(1, index) == 1) 
    % Recur down the right side
    classifications = id3TreeClassify_multi(tree.right, totalData, features); 
else
    % Recur down the left side
    classifications = id3TreeClassify_multi(tree.left, totalData, features);
end

return

end

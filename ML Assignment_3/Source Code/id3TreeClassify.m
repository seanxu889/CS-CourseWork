function [classifications] = id3TreeClassify(tree, totalData, features)

% Store the actual classification
actual = totalData(1, size(totalData,2));

% Recursion with three cases
% Case 1: Current node is labeled 'true'
if (strcmp(tree.value, 'true') == 1)
    classifications = [1, actual];
    return
end

% Case 2: Current node is labeled 'false'
if (strcmp(tree.value, 'false') == 1)
    classifications = [0, actual];
    return
end

% Case 3: Current node is labeled as an feature
index = find(ismember(features,tree.value)==1);
if (totalData(1, index) == 1)
    % Down to the right side
    classifications = id3TreeClassify(tree.right, totalData, features); 
else
    % Down to the left side
    classifications = id3TreeClassify(tree.left, totalData, features);
end

return

end

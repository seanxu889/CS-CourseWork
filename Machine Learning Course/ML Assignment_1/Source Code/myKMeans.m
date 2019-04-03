%% This is he main function
function [] = myKMeans(X,k)
    
    dim = size(X,2);

    if dim == 2
        plot(X(:,1),X(:,2),'kx'), title('The initial setup visualization');
        [u,re] = doKMeans(X,k);
    
    elseif dim == 3
        plot3(X(:,1),X(:,2),X(:,3),'kx'), title('The initial setup visualization');
        grid on;
        
        % Implement k-means
        [u,re] = doKMeans(X,k);
    
    elseif dim > 3
        % Reduces the data to 3D using PCA
        [vec_km,val_km] = eigs(cov(X),3);
        W_km = vec_km;
        Z_km = X * W_km;

        plot3(Z_km(:,1),Z_km(:,2),Z_km(:,3),'kx'), title('The initial setup visualization');
        grid on;
        
        % Implement k-means
        [u,re] = doKMeans(Z_km,k);
    
    end
end
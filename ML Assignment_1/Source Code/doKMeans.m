%% Implement K-means function
function [u,re]=doKMeans(data,k)   
    [m,n]=size(data); 
    iteCount = 0;
    
    % k random observations for the initial reference vectors
    rand('seed',0);
    selK = round(m / k * rand);
    u = []; 
    for i = 1:k
        u = [u; data(selK+round(m/k)*(i-1),:)];
    end
    
    while 1
        iteCount = iteCount+1;
        
        % the cluster centers from previous iteration
        pre_u = u;            
        for i=1:k
            tmp{i}=[];    
            for j=1:m
                tmp{i} = [tmp{i};data(j,:)-u(i,:)];
            end
        end
        
        quan = zeros(m,k);
        for i=1:m  
            c=[];
            for j=1:k
                c = [c norm(tmp{j}(i,:))];
            end
            [~,index]=min(c);
            quan(i,index)=norm(tmp{index}(i,:));           
        end
        
        for i=1:k   
           for j=1:n
               u(i,j)=sum(quan(:,i).*data(:,j))/sum(quan(:,i));
           end           
        end
        
        ss = 0;
        for p=1:k
            s = sum(abs(pre_u(p,:)-u(p,:)));
            ss = ss + s;
        end
        
        % Prepare the data to plot
        re=[];
        for i=1:m
            tmpp=[];
            for j=1:k
                tmpp=[tmpp norm(data(i,:)-u(j,:))];
            end
            [~,index2]=min(tmpp);
            re=[re;data(i,:) index2];  
        end
        
        % Call plot function
        if n==3
            plotCurrent(re,m,k,u,iteCount);
            pause(0.2)
        elseif n==2
            plotCurrent2(re,m,k,u,iteCount);
            pause(0.2)
        end
            
        if ss<2^-3
            if n==3
                % Rotate
                for y=1:1.5:350
                view(y,20);
                pause(0.05);
                end
                break;
            elseif n==2
                break;
            end
        end              
    end    
    
end

%% Plot function for 3D plot
function [] = plotCurrent(re,m,k,u,iteCount)
    
    figure(2);
    % Create a color matrix (the max k is seven)
    colMat = [0 0 1;1 0 0;0 1 0;0 0 0;1 1 0;1 0 1;0 1 1];
    
    for r=1:k
        for i=1:m 
            if re(i,4)==r   
                plot3(re(i,1),re(i,2),re(i,3),'x','Color',colMat(r,:)); 
                title(['Iteration' num2str(iteCount)]);      
            hold on
            end
        end    
    end
    
    for t=1:k
        plot3(u(t,1),u(t,2),u(t,3),'Marker','O','Markerfacecolor',colMat(t,:),'MarkerEdgeColor','k','MarkerSize',12); 
    end

    grid on;
    hold off;

end
    
%% Plot function for 2D plot
function [] = plotCurrent2(re,m,k,u,iteCount)
    
    figure(2);
    % Create a color matrix (the max k is seven)
    colMat = [0 0 1;1 0 0;0 1 0;0 0 0;1 1 0;1 0 1;0 1 1];
    
    for r=1:k
        for i=1:m 
            if re(i,3)==r   
                plot(re(i,1),re(i,2),'x','Color',colMat(r,:)); 
                title(['Iteration' num2str(iteCount)]);      
            hold on
            end
        end    
    end
    
    for t=1:k
        plot(u(t,1),u(t,2),'Marker','O','Markerfacecolor',colMat(t,:),'MarkerEdgeColor','k','MarkerSize',12); 
    end

    grid on;
    hold off;
    
end
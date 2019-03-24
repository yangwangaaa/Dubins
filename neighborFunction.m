
% 邻域计算函数
function neigh = neighborFunction(Weight,winner,r,t)
G = 5; % 可调整参数
a = 0.1;
mat = size(Weight);
n = mat(1,2);

% dist=distfunction_Neigh(weight,winner);

dist=Weight-winner*ones(1,n);
dist=sum(dist.^2);
dist=dist.^0.5;

neigh = 0 * ones(1,n);
for i = 1:n
    if(dist(i) >= r)
        neigh(i) = 0;
    end
    if(dist(i) < r)
        neigh(i) = exp(-dist(i)/((1-a) * G));
    end
end


function [J,ind,distn] = distanceFunction (x,Robot)
[m,n] = size(Robot);
dist = x*ones(1,n) - Robot; 
dist = sum(dist.^2); 
distn = dist.^0.5;
[J,ind] = min(distn); 


%获胜神经元的移动方式计算
function [x,y] = moveFunction(winnerT,weight)
dist = sum((winnerT - weight).^2);
dist = dist^.5;
% theta = arccos((winnerT(1,1) - weight(1,1))/dist);
T1 = (winnerT(1,1) - weight(1,1))/dist;
T2 = (winnerT(2,1) - weight(2,1))/dist;
%if((winnerT(1,1) - weight(1,1))<0)
%end
%if((winnerT(1,1) - weight(1,1))>=0)
     x = T1;
     y = T2;
%end
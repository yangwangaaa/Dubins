function [J,ind,distn] = obstacleFunction(Target,Robot,TargetV,RobotV,Obstacle,ObstacleR,monitor,max,maxDis,turnR,flag)
%调用原函数距离排序
[J,ind,distn] = distanceFunction(Target,Robot); 
% 1 = ii;
Nm = ind; 
% 取得获胜神经元
winnerR = Robot(:,Nm); 
winnerT = Target;

%对获胜神经元进行效验（采用循环+迭代）
Mat = size(Obstacle); 
ObstacleNum = Mat(1,2);
for i=1:ObstacleNum%以障碍物作为循环条件+任务负载判断
    
    if(monitor(1,Nm)==max||monitor(1,Nm)>maxDis)
        Robot(:,Nm)=9999999;%本次置无限大
        [J,ind,distn] = obstacleFunction(Target,Robot,TargetV,RobotV,Obstacle,ObstacleR,monitor,max,maxDis,turnR,flag);
    end
    
    %直线与障碍物判断函数若返回负数则说明障碍物与直线有交点
    if(flag==0)%直线模式则直接使用直线公式判断障碍物和直线关系 obstacleLineFunction(x1,y1,x2,y2,Obstacle,ObstacleR)
        oxflag = obstacleLineFunction(winnerR(1,1),winnerR(2,1),winnerT(1,1),winnerT(2,1),Obstacle(:,i),ObstacleR);
    elseif(flag==1)%dubins路径完整版需先求出返回的直线坐标再进行判断
        
        %调用dubins计算函数计算出两个切点进行直线障碍物判断
        %[xa,ya,xb,yb] = dubinsCalculateFunction(R,x0,y0,phi1,a0,b0,theta1)
            [xa,ya,xb,yb] = dubinsCalculateFunction(turnR,winnerR(1,1),winnerR(2,1),RobotV(2,Nm),winnerT(1,1),winnerT(2,1),TargetV(2,1));
        %初步判断两点间是否能构成dubins路径条件为两点直线距离大于两倍转弯半径（turnR）
        dis=((winnerR(1,1)-winnerT(1,1))^2+(winnerR(2,1)-winnerT(2,1))^2)^0.5;
        %当方向一致时，可以不考虑两倍转弯半径
        if(dis<2*turnR)
            Robot(:,Nm)=9999999;%本次置无限大
            [J,ind,distn] = obstacleFunction(Target,Robot,TargetV,RobotV,Obstacle,ObstacleR,monitor,max,maxDis,turnR,flag);
        end
        oxflag = obstacleLineFunction(xa,ya,xb,yb,Obstacle(:,i),ObstacleR);
    end
    
    if(oxflag < 0)
        Robot(:,Nm)=9999999;%本次置无限大
        [J,ind,distn] = obstacleFunction(Target,Robot,TargetV,RobotV,Obstacle,ObstacleR,monitor,max,maxDis,turnR,flag);
    end
    
end
    
end



           
            

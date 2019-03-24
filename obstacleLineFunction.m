function oxflag = obstacleLineFunction(x1,y1,x2,y2,Obstacle,ObstacleR)
    
    oxflag=1;%先赋个正值
    %获取障碍物坐标范围极值
    Oxmin=Obstacle(1,1)-ObstacleR;
    Oxmax=Obstacle(1,1)+ObstacleR;
    Oy=Obstacle(2,1);

%-----------------------直线的计算公式 用于判断障碍物-----------------------%
                     %先判断y值是否在机器人和目标点之间
                   %再判断x值是否在目标直线的两端，乘积＜0
            if(((Oy-y1)*(Oy-y2))<=0)
                if(x1 ~= x2)%x不等求k
                    if(x1<x2)
                        x=x1:0.1:x2;
                    elseif(x1>x2)
                        x=x2:0.1:x1;
                    end
                    k=(y1-y2)/(x1-x2);
                    b=y1-k.*x1;
                    %获取横坐标参照值
                    Ox=(Oy-b)/k;
                    oxflag=(Ox-Oxmin)*(Ox-Oxmax);%若小于0则阻挡路径需要重新计算
    %                 y=k.*x+b;
    %                 plot(x,y);
                end
                if(x1 == x2)
                    if(y1<=y2)
                        y=y2:0.1:y1;
                    elseif(y1>y2)
                        y=y1:0.1:y2;
                    end
                    x=x1;
                    oxflag=(x-Oxmin)*(x-Oxmax);%若小于0则阻挡路径需要重新计算
    %                 plot(x,y);
                end
            end
%-------------------------------------------------------------------------%
    
    
end



           
            

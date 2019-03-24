%程序入口
clear all;
close all; 
% 设置AUV工作区域
xmin = [0; 0];  
xmax = [50;50]; 

%！！！通用参数设置！！！%
% 设置AUV和目标点的参数
% 设定目标
Target = [
          15 24;
          10.5 11;
          4 3;
          18 6;
          4 20;
          20 13;
%           9 8;
%          20 20;
%          7 14;
         ]';     


% 设定机器人矢量，速度、与X正半轴夹角
TargetV = [
           0 1*pi/4;
           0 2*pi/4;
           0 2*pi/4;
           0 2*pi/4;
           0 3*pi/4;
           0 2*pi/4;
           0 2*pi/4;
           0 3*pi/4
          ]'; 

% 设定机器人
Robot = [
%     20 20;
%          16 23;
         12 21;
%          11 16;
         4 10;
%          24 1;
%          23 16;
%          9 8;
%          20 20;
%          7 14;
        ]'; 

% 设定机器人矢量，速度、与X正半轴夹角
RobotV = [
          0 3*pi/4;
          0 2*pi/4;
          0 1*pi/4;
          0 1*pi/4;
          0 2*pi/4;
          0 1*pi/4;
          0 1*pi/4;
          0 1*pi/4;
          0 1*pi/4
         ]'; 

% 设定障碍物
%0-不显示 1-显示
ObstacleFlag = 1;
%障碍物矩阵
Obstacle = [
            -1 0;
            7.5 15;
%             22 15;
%             4 5
           ]'; 
ObstacleR = 1; %障碍物半径


%效验四个矩阵数据
Mat1 = size(Target); 
TarNum = Mat1(1,2);
Mat2 = size(Robot); 
RorNum = Mat2(1,2);
Mat3 = size(TargetV); 
TarVNum = Mat3(1,2);
Mat4 = size(RobotV); 
RorVNum = Mat4(1,2);
if(TarNum~=TarVNum||RorNum~=RorVNum)
%     error('初始化数组长度错误')
end

%根据机器人的数量初始化记录任务和距离的数组
%第一行记录对应号码机器人的任务数量
%第二行记录对应号码机器人的行走距离（单位长度）
RobortMonitor  = zeros(2,RorNum);
%负载设定上限：向上取整
taskMax=ceil(TarNum/RorNum)+1;
% taskMax=3;
%最大行走距离判断
maxDis=taskMax*100;

%洋流参数
currentFlag=0;%洋流参数启用标志 0-不启用；1-启用
vc=1;%偏移长度
ai=30*pi/180;

%！！！轨迹参数！！！%
%直线dubins参数
%0-直线
%1-dubins（目标和机器人都有速度向量） 
%2-dubins（机器人带速度向量）
lineFlag=1;

%转弯半径
turnR=1;
%-------------------------------------------------------------------------%

% 神经网络初始状态
figure
% plot(Robot(1,:),Robot(2,:),'.r','MarkerSize',10);
plot(Robot(1,:),Robot(2,:),'.r','LineWidth', 2, 'Marker', 'd');
axis([0 24 0 30]); 
xlabel('X 轴')
ylabel('Y 轴','rotation',0)
title('初始位置分配')
hold on
plot(Target(1,:),Target(2,:),'.g','MarkerSize',30);
hold on
if(ObstacleFlag==0)
    legend('机器人','任务目标',2);
elseif(ObstacleFlag==1)
    plot(Obstacle(1,:),Obstacle(2,:),'.k','Marker', 'x','MarkerSize',10);
    legend('机器人','任务目标','障碍物',2);
end
hold on
axis equal
Weight{1} = Robot;
WeightV{1} = RobotV;
Target_a = Target;
B = 0.2; % 可调参数
r = 0.5; % 可调参数
w = 1; %机器人参数，当前第一个开始
temp = -1;
tt = 1;

%另画一张图
figure
plot(Robot(1,:),Robot(2,:),'.r','LineWidth', 2, 'Marker', 'd');
axis([0 24 0 30]); 
xlabel('X 轴')
ylabel('Y 轴','rotation',0)
title('任务位置分配')
hold on
plot(Target_a(1,:),Target_a(2,:),'.g','MarkerSize',30);
hold on
if(ObstacleFlag==0)
    legend('机器人','任务目标',2);
elseif(ObstacleFlag==1)
    plot(Obstacle(1,:),Obstacle(2,:),'.k','Marker', 'x','MarkerSize',10);
    legend('机器人','任务目标','障碍物',2);
end
hold on
axis equal
% 主循环
% for t = 1:Step
    t=1;
    for ii=1:TarNum 
       % 原函数（计算距离并排序）
%        [Dist{t}(ii),ind(ii),distn] = distanceFunction(Target_a(:,ii),Weight{w}); 
       
       %障碍物判断函数/参数：本次任务目标，当前机器人矩阵
       [Dist{t}(ii),ind(ii),distn] = obstacleFunction(Target_a(:,ii),Weight{w},TargetV(:,ii),WeightV{w},Obstacle,ObstacleR,RobortMonitor,taskMax,maxDis,turnR,lineFlag);
      
       Nk = ii;
       Nm = ind(Nk); 
       % 取得获胜神经元
       winnerR = Weight{w}(:,Nm); 
       winnerT = Target_a(:,Nk);
       %更新监视器任务数量
       RobortMonitor(1,Nm) = RobortMonitor(1,Nm)+1;
       
       flag=1;
       
       if(Dist{t}(ii) <= 0.1)
           temp(tt) = ii;
           tt = tt+1;
       end
       flag = 1;
       for zz = 1:tt-1
           if(ii == temp(zz))
               flag = 0;
           end
       end
    
       if(flag == 1)
%            获胜神经元邻域更新
           Neigh{w} = neighborFunction(Weight{w},winnerR,r,t); 
%            	不考虑/考虑抵消海流算法的影响
           Weight{w+1} = updateCurrentFunction(Weight{w}, B, Neigh{w}, distn, winnerT, Dist{t}(ii),vc,ai,currentFlag);

%             画直线
%             使用当前获胜机器人&获胜目标
%               line([Weight{w}(1,Nm),Target_a(1,Nk)],[Weight{w}(2,Nm),Target_a(2,Nk)])
%             使用当前获胜机器人(w)和更新的新机器人(w+1)位置画直线（更新的新机器人位置可能含洋流变化）
%               line([Weight{w}(1,Nm),Weight{w+1}(1,Nm)],[Weight{w}(2,Nm),Weight{w+1}(2,Nm)])
              
              %返回行走距离
              if(lineFlag==0)
                  currentDistance = printerLineFunction(Weight{w}(1,Nm),Weight{w+1}(1,Nm),Weight{w}(2,Nm),Weight{w+1}(2,Nm),'b',2);
              elseif(lineFlag==1)%(R,x0,y0,phi1,a0,b0,theta1)
                  currentDistance = printerDubinsFunction(turnR,winnerR(1,1),winnerR(2,1),WeightV{w}(2,Nm),winnerT(1,1),winnerT(2,1),TargetV(2,Nk),'r',2);
              end
              %更新机器人速度向量
              WeightV{w+1}=WeightV{w};
              WeightV{w+1}(2,Nm)=TargetV(2,Nk);
              %更新监视器累积行走距离
              RobortMonitor(2,Nm) = RobortMonitor(2,Nm)+currentDistance;
            w = w + 1;
       end
    end
    

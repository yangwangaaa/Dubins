function currentDistance = printerDubinsFunction(R,x0,y0,phi1,a0,b0,theta1,color,width)

% R=1;
% x0=8;
% y0=8;
phi0=phi1/pi*180;
x=x0+R*cos((phi0+90)/57.3);   %逆时针圆圆心--起始圆（上圆）
y=y0+R*sin((phi0+90)/57.3);
plot([x],[y],'.m')
hold on

x1=x0+R*cos((phi0-90)/57.3);  %顺时针圆圆心--起始圆（上圆）
y1=y0+R*sin((phi0-90)/57.3);
plot([x1],[y1],'.m')

% a0=1;
% b0=1;
theta0=theta1/pi*180;
a=a0+R*cos((theta0+90)/57.3);    %逆时针圆圆心--终止圆（下圆）
b=b0+R*sin((theta0+90)/57.3);
plot([a],[b],'.m')

a1=a0+R*cos((theta0-90)/57.3);    %顺时针圆圆心--终止圆（下圆）
b1=b0+R*sin((theta0-90)/57.3);
plot([a1],[b1],'.m')




dubinsCycleHelper(x,y,R,0,2*pi,'--b',1);
dubinsCycleHelper(x1,y1,R,0,2*pi,'--b',1);
dubinsCycleHelper(a,b,R,0,2*pi,'--b',1);
dubinsCycleHelper(a1,b1,R,0,2*pi,'--b',1);
quiver(x0,y0,R*cos(phi0/57.3),R*sin(phi0/57.3),'r','filled','LineWidth',2)%机器人
quiver(a0,b0,R*cos(theta0/57.3),R*sin(theta0/57.3),'g','filled','LineWidth',2)%任务点

%圆心距
L1=sqrt((x-a)*(x-a)+(y-b)*(y-b));
L2=sqrt((x-a1)*(x-a1)+(y-b1)*(y-b1));
L3=sqrt((x1-a)*(x1-a)+(y1-b)*(y1-b));
L4=sqrt((x1-a1)*(x1-a1)+(y1-b1)*(y1-b1));

[Lmin,index] = min([L1 L2 L3 L4]); 
switch index
    case 1%x,y a,b 起始圆逆终止圆逆
        
        %左对左
%         alpa=pi/2+atan(R/L1);
        alpa=pi/2;
        F=[a;b]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[x-a;y-b]*R/L1;
        xb=F(1);       %切点坐标
        yb=F(2);
        alpa=alpa+pi;
        I=[x;y]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[a-x;b-y]*R/L1;
        xa=I(1);       %起点坐标
        ya=I(2);
        
        ofa=a;
        ofb=b;
        oia=x;
        oib=y;
    case 2%x,y a1,b1 起始圆逆终止圆顺
        
        %左对右
%         alpa=-pi/2+atan(2*R/L2);
        alpa=-(pi/2-asin(2*R/L2));
        F=[a1;b1]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[x-a1;y-b1]*R/L2;
        xb=F(1);       %切点坐标
        yb=F(2);
        I=[x;y]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[a1-x;b1-y]*R/L2;
        xa=I(1);       %起点坐标
        ya=I(2);
        
        ofa=a1;
        ofb=b1;
        oia=x;
        oib=y;
    case 3%x1,y1 a,b 起始圆逆终止圆顺
        
        %右对左
%         alpa=pi/2-atan(2*R/L1);
        alpa=pi/2-asin(2*R/L3);
        F=[a;b]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[x1-a;y1-b]*R/L3;
        xb=F(1);       %切点坐标
        yb=F(2);
        I=[x1;y1]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[a-x1;b-y1]*R/L3;
        xa=I(1);       %起点坐标
        ya=I(2);
        
        ofa=a;
        ofb=b;
        oia=x1;
        oib=y1;
    case 4%x1,y1 a1,b1 起始圆顺终止圆顺
        
        %右对右
%         alpa=-pi/2+atan(R/L4);
        alpa=-pi/2;
        F=[a1;b1]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[x1-a1;y1-b1]*R/L4;
        xb=F(1);       %切点坐标
        yb=F(2);
        alpa=alpa+pi;
        I=[x1;y1]+[cos(alpa) -sin(alpa);sin(alpa) cos(alpa)]*[a1-x1;b1-y1]*R/L4;
        xa=I(1);       %起点坐标
        ya=I(2);
        
        ofa=a1;
        ofb=b1;
        oia=x1;
        oib=y1;
    otherwise
        error('异常')
end

% 补圆弧--暂时还有问题需改进
% 圆在上则画上半段 圆在下则画下半段
% x0,y0,xa,ya
% a0,b0,xb,yb
rad1=dubinsRadHelper(oia,oib,x0,y0,xa,ya,R,phi0,0,color,width);%起点 圆心 起点 切点
rad2=dubinsRadHelper(ofa,ofb,a0,b0,xb,yb,R,theta0,1,color,width);%终止 圆心 起点 切点
L1 = printerLineFunction(xa,xb,ya,yb,color,width);

% L1=sqrt((xa-xb)*(xa-xb)+(ya-yb)*(ya-yb));   %切线长度
C1=rad1*R;
C2=rad2*R;
currentDistance=L1+C1+C2;

end
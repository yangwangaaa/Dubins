function  radC=dubinsRadHelper(ox,oy,xa,ya,xb,yb,R,rad,flag,~,width)%圆心、初始点、切点、半径、向量、0-起点 1-终点

%起始点-圆心的向量
tx1=xa-ox;
ty1=ya-oy;
% a*b/[|a|*|b|]
%求初始点圆心和X轴求夹角(1,0)
p=(tx1*1+ty1*0)/(((tx1^2+ty1^2)^0.5)*((1^2+0^2)^0.5));
o=acos(p);
if(ty1<0)%如果y坐标小于0 则夹角为负
    o=-o;
end
if(o<0)%将负角度转换为正角度
    o=o+2*pi;
end

%切点-圆心的向量
tx2=xb-ox;
ty2=yb-oy;
%求切点圆心和X轴求夹角(1,0)
% t=(tx1*tx2+ty1*ty2)/(((tx1^2+ty1^2)^0.5)*((tx2^2+ty2^2)^0.5));
t=(tx2*1+ty2*0)/(((tx2^2+ty2^2)^0.5)*((1^2+0^2)^0.5));
q=acos(t);
if(ty2<0)%如果y坐标小于0 则夹角为负
    q=-q;
end
if(q<0)%将负角度转换为正角度
    q=q+2*pi;
end

%效验角度关系，当差值在0.01内则认为为同一角度，不绘制弧度
if(o>=q)
    temp=o-q;
elseif(o<q)
    temp=q-o;
end

if(temp>0.01)
    %rad-向量 o-起始点-圆心的向量 q-切点-圆心的向量
    %ox,oy,xa,ya,xb,yb,R - 圆心、初始点、切点、半径
    % 0-起点 1-终点
    if(flag==0)%起点，顺着出去
        if(0<=rad&&rad<=180)%向量向上
            if(ox>xa)%圆在向量右边（顺圆）o-q
                if(o>=q)%说明0<q<o
                    dubinsCycleHelper(ox,oy,R,q,o,'-r',width);
                    radC=o-q;
                elseif(o<q)%说明o<q<360
                    dubinsCycleHelper(ox,oy,R,0,o,'-r',width);
                    dubinsCycleHelper(ox,oy,R,q,2*pi,'-r',width);
                    radC=o+2*pi-q;
                end
            elseif(ox<xa)%圆在向量左边（逆圆）o-q
                if(o>=q)%
                    dubinsCycleHelper(ox,oy,R,0,q,'-r',width);
                    dubinsCycleHelper(ox,oy,R,o,2*pi,'-r',width);
                    radC=q+2*pi-o;
                elseif(o<q)%
                    dubinsCycleHelper(ox,oy,R,o,q,'-r',width);
                    radC=q-o;
                end
            end
        elseif(180<rad&&rad<=360)%向量向下
            if(ox>xa)%圆在向量右边（逆圆）o-q
                if(o>=q)%
                    dubinsCycleHelper(ox,oy,R,0,q,'-r',width);
                    dubinsCycleHelper(ox,oy,R,o,2*pi,'-r',width);
                    radC=q+2*pi-o;
                elseif(o<q)%
                    dubinsCycleHelper(ox,oy,R,o,q,'-r',width);
                    radC=q-o;
                end
            elseif(ox<xa)%圆在向量左边（顺圆）o-q
                if(o>=q)%
                    dubinsCycleHelper(ox,oy,R,q,o,'-r',width);
                    radC=o-q;
                elseif(o<q)%
                    dubinsCycleHelper(ox,oy,R,0,o,'-r',width);
                    dubinsCycleHelper(ox,oy,R,q,2*pi,'-r',width);
                    radC=o+2*pi-q;
                end
            end
        end
    elseif(flag==1)%终点，顺着进入
        if(0<rad&&rad<=180)%向量向上
            if(ox>xa)%圆在向量右边（顺圆）q-o
                if(o>=q)%说明0<q<o
                    dubinsCycleHelper(ox,oy,R,0,q,'-r',width);
                    dubinsCycleHelper(ox,oy,R,o,2*pi,'-r',width);
                    radC=q+2*pi-o;
                elseif(o<q)%说明o<q<360
                    dubinsCycleHelper(ox,oy,R,o,q,'-r',width);
                    radC=q-o;
                end
            elseif(ox<xa)%圆在向量左边（逆圆）q-o
                if(o>=q)%
                    dubinsCycleHelper(ox,oy,R,q,o,'-r',width);
                    radC=o-q;
                elseif(o<q)%
                    dubinsCycleHelper(ox,oy,R,0,o,'-r',width);
                    dubinsCycleHelper(ox,oy,R,q,2*pi,'-r',width);
                    radC=o+2*pi-q;
                end
            end
        elseif(180<rad&&rad<=360||rad==0)%向量向下
            if(ox>xa)%圆在向量右边（逆圆）q-o
                if(o>=q)%
                    dubinsCycleHelper(ox,oy,R,q,o,'-r',width);
                    radC=o-q;
                elseif(o<q)%
                    dubinsCycleHelper(ox,oy,R,0,o,'-r',width);
                    dubinsCycleHelper(ox,oy,R,q,2*pi,'-r',width);
                    radC=o+2*pi-q;
                end
            elseif(ox<xa)%圆在向量左边（顺圆）q-o
                if(o>=q)%
                    dubinsCycleHelper(ox,oy,R,0,q,'-r',width);
                    dubinsCycleHelper(ox,oy,R,o,2*pi,'-r',width);
                    radC=q+2*pi-o;
                elseif(o<q)%
                    dubinsCycleHelper(ox,oy,R,o,q,'-r',width);
                    radC=q-o;
                end
            end
        end
    end
end

end
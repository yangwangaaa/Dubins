function dubinsCycleHelper(x0,y0,r,begins,ends,style,width)

sita=begins:pi/100:ends;
plot(x0+r*cos(sita),y0+r*sin(sita),style,'LineWidth',width);

end
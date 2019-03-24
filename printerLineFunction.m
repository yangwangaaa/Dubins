function currentDistance = printerLineFunction(x1,x2,y1,y2,color,width)
    line([x1,x2],[y1,y2],'Color',color,'LineWidth',width);
    currentDistance=((x1-x2)^2+(y1-y2)^2)^0.5;
end
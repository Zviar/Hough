function [point,rectangleBoxs] = hough_rectangle(BW,thresh,MaxNum,distance)
%霍夫变换检测矩形
%input
% BW：二值图像
% thresh：平行边差异度阈值
% MaxNum:平行边检测最大数量，至少为2，MaxNum越大能检测的矩形越多
% MaxNum,distance:判断相近点距离阈值，顶点距离低于distance_point的两个矩形会被视为一个矩形  

% output：  
% point:组成矩形的顶点组  
% rectangleBoxs:组成矩形的x,y,L,W
[H, theta, rho]=hough(BW,'Theta',-3:3);%theat是霍夫变换的角度θ，rho是霍夫变换ρ轴的位置，Theta模式可以指定霍尔转换的角度范围
peaks=houghpeaks(H,MaxNum); %number of peaks
lines=houghlines(BW, theta, rho, peaks);
point = [];
rectangleBoxs = [];
for i = 1:(length(lines) - 1)
    for j = 1 + i:length(lines)
        dif = (abs(lines(i).point1(2) - lines(j).point1(2)) + abs(lines(i).point2(2) - lines(j).point2(2))) / (abs(lines(i).point2(2) - lines(i).point1(2) + lines(j).point2(2) - lines(j).point1(2))/2);
        if dif <= thresh%dif：平行边差异度阈值
            %矩形
            L = abs(lines(i).point1(1) - lines(j).point2(1));
            W = abs(lines(i).point1(2) - lines(i).point2(2));
            if (lines(i).point1(1) - lines(j).point2(1)) < 0
                x = lines(i).point1(1);
            else
                x = lines(j).point1(1);
            end
            y = lines(i).point1(2);
            rectangleBox = [x,y,L,W];
            rectangleBoxs = [rectangleBoxs;rectangleBox];
            %四边形
            point_x = [lines(i).point1(1),lines(i).point2(1),lines(j).point2(1),lines(j).point1(1),lines(i).point1(1)];
            point_y = [lines(i).point1(2),lines(i).point2(2),lines(j).point2(2),lines(j).point1(2),lines(i).point1(2)];
            point = [point;point_x,point_y];
            %检测新的方框与之前方框距离,防止重复绘制
            if size(rectangleBoxs) >= 2
                for k = 1:(size(rectangleBoxs)-1)
                    d = sqrt((rectangleBox(1)-rectangleBoxs(k,1))^2 + (rectangleBox(2)-rectangleBoxs(k,2))^2);%顶点距离
                    if d <= distance
                        rectangleBoxs(end,:) = [];
                        point(end,:) = [];
                        break;
                    end
                end
            end
        end
    end
end

end


close all;
clear all;
clc;
f=rgb2gray(imread('t2.jpg'));
%edge
f2 = edge(f,'canny',0.2);%边缘检测，canny算子
figure;
imshow(f2);
SE = strel('square',1);%设置结构元素
f2 = imdilate(f2,SE);%膨胀
f2 = imfill(f2,'holes');%填补空洞
SE = strel('square',20);%设置结构元素
f2 = imerode(f2,SE);%腐蚀
f2 = imdilate(f2,SE);%膨胀
f2 = edge(f2,'canny');%边缘检测，canny算子
figure;
imshow(f2);

%设置矩形检测参数
thresh_rec = 0.2;%矩形平行边差异值，取值0-1之间
thresh_MaxNum = 10;%平行边检测最大数量，至少为2，MaxNum越大能检测的矩形越多
distance_point = 30;%判断相近点距离阈值，顶点距离低于distance_point的两个矩形会被视为同一个矩形

%检测矩形
[point_rec,rectangleBoxs] = hough_rectangle(f2,thresh_rec,thresh_MaxNum,distance_point);

%设置圆形检测参数
Step_r = 0.5;%检测圆半径步长
Step_angle = 0.1;%角度步长，单位为弧度
minr = 30;%最小圆半径
maxr =100;%最大圆半径
thresh_cir = 0.6;%以thresh*hough_space的最大值为阈值，取值0-1之间

[Hough_circle_result,Para] = Hough_circle(f2,Step_r,Step_angle,minr,maxr,thresh_cir);
circleParaXYR = Para;%y,x,r
% figure; 
% imshow(Hough_circle_result);

%清除矩形内的圆
for i = size(circleParaXYR):-1:1
    for k = 1:size(rectangleBoxs)
        if (circleParaXYR(i,2) > rectangleBoxs(k,1)) && ((circleParaXYR(i,2)-rectangleBoxs(k,1)) < rectangleBoxs(k,3)) && (circleParaXYR(i,1) > rectangleBoxs(k,2)) && ((circleParaXYR(i,1)-rectangleBoxs(k,2)) < rectangleBoxs(k,4))
            circleParaXYR(i,:) = [];
            break;
        end
    end
end

figure; 
imshow(f);
hold on
%绘制矩形，以下两种方法选一种
for i = 1:size(rectangleBoxs)
    %绘制矩形,适用水平矩形，线段不贴合检测出的图形，线段为重绘的矩形框
    rectangleBox = [rectangleBoxs(i,1)-3,rectangleBoxs(i,2)-3,rectangleBoxs(i,3)+6,rectangleBoxs(i,4)+6];
    rectangle('Position',rectangleBox,'LineWidth',2,'EdgeColor','r') ;
    
    %绘制四边形,适用于非水平矩形，线段贴合检测出的图形
%     x = [point_rec(i,1),point_rec(i,2),point_rec(i,3),point_rec(i,4),point_rec(i,5)];
%     y = [point_rec(i,6),point_rec(i,7),point_rec(i,8),point_rec(i,9),point_rec(i,10)];
%     plot(x,y, 'LineWidth', 1, 'Color', 'r');
end
%绘制圆形
%plot(circleParaXYR(:,2), circleParaXYR(:,1), 'r+');%绘制圆心
for k = 1:size(circleParaXYR, 1) 
	t=0:0.01*pi:2*pi;
	x=cos(t).*circleParaXYR(k,3)+circleParaXYR(k,2);
	y=sin(t).*circleParaXYR(k,3)+circleParaXYR(k,1);
	plot(x,y,'r-');
end 







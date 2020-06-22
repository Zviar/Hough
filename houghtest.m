close all;
clear all;
clc;
f=rgb2gray(imread('t2.jpg'));
%edge
f2 = edge(f,'canny',0.2);%��Ե��⣬canny����
figure;
imshow(f2);
SE = strel('square',1);%���ýṹԪ��
f2 = imdilate(f2,SE);%����
f2 = imfill(f2,'holes');%��ն�
SE = strel('square',20);%���ýṹԪ��
f2 = imerode(f2,SE);%��ʴ
f2 = imdilate(f2,SE);%����
f2 = edge(f2,'canny');%��Ե��⣬canny����
figure;
imshow(f2);

%���þ��μ�����
thresh_rec = 0.2;%����ƽ�б߲���ֵ��ȡֵ0-1֮��
thresh_MaxNum = 10;%ƽ�б߼���������������Ϊ2��MaxNumԽ���ܼ��ľ���Խ��
distance_point = 30;%�ж�����������ֵ������������distance_point���������λᱻ��Ϊͬһ������

%������
[point_rec,rectangleBoxs] = hough_rectangle(f2,thresh_rec,thresh_MaxNum,distance_point);

%����Բ�μ�����
Step_r = 0.5;%���Բ�뾶����
Step_angle = 0.1;%�ǶȲ�������λΪ����
minr = 30;%��СԲ�뾶
maxr =100;%���Բ�뾶
thresh_cir = 0.6;%��thresh*hough_space�����ֵΪ��ֵ��ȡֵ0-1֮��

[Hough_circle_result,Para] = Hough_circle(f2,Step_r,Step_angle,minr,maxr,thresh_cir);
circleParaXYR = Para;%y,x,r
% figure; 
% imshow(Hough_circle_result);

%��������ڵ�Բ
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
%���ƾ��Σ��������ַ���ѡһ��
for i = 1:size(rectangleBoxs)
    %���ƾ���,����ˮƽ���Σ��߶β����ϼ�����ͼ�Σ��߶�Ϊ�ػ�ľ��ο�
    rectangleBox = [rectangleBoxs(i,1)-3,rectangleBoxs(i,2)-3,rectangleBoxs(i,3)+6,rectangleBoxs(i,4)+6];
    rectangle('Position',rectangleBox,'LineWidth',2,'EdgeColor','r') ;
    
    %�����ı���,�����ڷ�ˮƽ���Σ��߶����ϼ�����ͼ��
%     x = [point_rec(i,1),point_rec(i,2),point_rec(i,3),point_rec(i,4),point_rec(i,5)];
%     y = [point_rec(i,6),point_rec(i,7),point_rec(i,8),point_rec(i,9),point_rec(i,10)];
%     plot(x,y, 'LineWidth', 1, 'Color', 'r');
end
%����Բ��
%plot(circleParaXYR(:,2), circleParaXYR(:,1), 'r+');%����Բ��
for k = 1:size(circleParaXYR, 1) 
	t=0:0.01*pi:2*pi;
	x=cos(t).*circleParaXYR(k,3)+circleParaXYR(k,2);
	y=sin(t).*circleParaXYR(k,3)+circleParaXYR(k,1);
	plot(x,y,'r-');
end 







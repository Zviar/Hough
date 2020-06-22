function [point,rectangleBoxs] = hough_rectangle(BW,thresh,MaxNum,distance)
%����任������
%input
% BW����ֵͼ��
% thresh��ƽ�б߲������ֵ
% MaxNum:ƽ�б߼���������������Ϊ2��MaxNumԽ���ܼ��ľ���Խ��
% MaxNum,distance:�ж�����������ֵ������������distance_point���������λᱻ��Ϊһ������  

% output��  
% point:��ɾ��εĶ�����  
% rectangleBoxs:��ɾ��ε�x,y,L,W
[H, theta, rho]=hough(BW,'Theta',-3:3);%theat�ǻ���任�ĽǶȦȣ�rho�ǻ���任�����λ�ã�Thetaģʽ����ָ������ת���ĽǶȷ�Χ
peaks=houghpeaks(H,MaxNum); %number of peaks
lines=houghlines(BW, theta, rho, peaks);
point = [];
rectangleBoxs = [];
for i = 1:(length(lines) - 1)
    for j = 1 + i:length(lines)
        dif = (abs(lines(i).point1(2) - lines(j).point1(2)) + abs(lines(i).point2(2) - lines(j).point2(2))) / (abs(lines(i).point2(2) - lines(i).point1(2) + lines(j).point2(2) - lines(j).point1(2))/2);
        if dif <= thresh%dif��ƽ�б߲������ֵ
            %����
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
            %�ı���
            point_x = [lines(i).point1(1),lines(i).point2(1),lines(j).point2(1),lines(j).point1(1),lines(i).point1(1)];
            point_y = [lines(i).point1(2),lines(i).point2(2),lines(j).point2(2),lines(j).point1(2),lines(i).point1(2)];
            point = [point;point_x,point_y];
            %����µķ�����֮ǰ�������,��ֹ�ظ�����
            if size(rectangleBoxs) >= 2
                for k = 1:(size(rectangleBoxs)-1)
                    d = sqrt((rectangleBox(1)-rectangleBoxs(k,1))^2 + (rectangleBox(2)-rectangleBoxs(k,2))^2);%�������
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


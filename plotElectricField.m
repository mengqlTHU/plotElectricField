function [] = plotElectricField(x_limit,y_limit,step,line_number,Q,posChargeX)
%取网格
s1 = -x_limit:step:0;
s2 = -y_limit:step:y_limit;
[x,y]=meshgrid(s1,s2);
u=zeros(size(y,1),size(x,2));
v=zeros(size(y,1),size(x,2));
%定义常数
posChargeLocation = [posChargeX;0];
negChargeLocation = [-posChargeX;0];
K = 9e9;
%算电场
for i=1:size(x,2)
    for j=1:size(y,1)
        r_pos = norm([x(j,i);y(j,i)]-posChargeLocation);
        r_neg = norm([x(j,i);y(j,i)]-negChargeLocation);
        E_pos = ([x(j,i);y(j,i)]-posChargeLocation)/r_pos^3;
        E_neg = -([x(j,i);y(j,i)]-negChargeLocation)/r_neg^3;
        E_vec = E_pos+E_neg;
        u(j,i) = E_vec(1);
        v(j,i) = E_vec(2);
    end
end

u=K*Q*u;
v=K*Q*v;

%取起始点
t=0:2*pi/line_number:2*pi;
rho = 0.05*ones(1,length(t));
[startx,starty]=pol2cart(t, rho);
startx = startx+posChargeX;

%绘图，镜像
sl = streamline(x,y,u,v,startx,starty);
hold on
for i=1:size(sl,1)
    plot(-get(sl(i,1),'XData'), get(sl(i,1),'YData'),'b') ;
end
plot(posChargeX,0,'ro','MarkerFaceColor','r');
plot(-posChargeX,0,'go','MarkerFaceColor','g');
axis equal;
end
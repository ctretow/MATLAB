function [max_Traj, omegaOpti, fiOpti,final_data,accuracy_golden_Section,error,x1,x2,F]=opti(data,L,h,max_Angle)
format long
fi=data(:,1);       %initial value 
omega=data(:,2);    %initial value
xL=L*sin(fi);       %point in x-dir at angle fi
yL=2.5-L*cos(fi);   %point in y-dir at angle fi
plot(xL,yL,'LineWidth', 2)
hold on
grid on
XYdata=[];                      %savevector
lengthdata=[];                  %savevector 
accuracy_golden_Section=0.01;   %accuracy
for i = 1:length(fi); 
%initial conditions
V=L*omega(i);               % velocity resultant lenght*(rad/s)
x=L.*sin(fi(i));            % x-position
Vy= V.*sin(fi(i));          % velocity component y-dir
y=2.5-L.*cos(fi(i));        % y-position
Vx=V.*cos(fi(i));           % velocity component x-dir
Y=[x, Vx, y Vy]; %initial conditions (values) vector [X-pos X-Vel Y-pos Y-Vel] 
    while Y(3) > 0 % RK4 condition
    %Runge-Kutta solution of air differential equations
    f1=flight2(Y);
    f2=flight2(Y+h.*f1/2);
    f3=flight2(Y+h.*f2/2);
    f4=flight2(Y+h.*f3);
    Y=Y+h.*(f1+2*f2+2*f3+f4)/6;
    XYdata=[XYdata; Y(:,1) Y(:,3)]; %saves data
    end
    %Linear-Interpolation
    % end points in Runge-kutta solution for interpolation between. 
    % one point above x-axis and one point below x-axis
  x=[(XYdata(end-1,1)) XYdata(end,1)]; %x-pos
  y=[(XYdata(end-1,2)) XYdata(end,2)]; %y-pos
  plot(x,y,'o') 
  line([0 2.5],[0 0]) %plot ground level at y=0
  plot(x,y,'-b','Linewidth',2)
  xlabel('x')
  ylabel('y')
  k=(y(2)-y(1))/(x(2)-x(1)); %k-value
  m=y(1)- k*x(1);            %m-value
  lengthdata(i,:)=m/(-k);    %intersection x-axis gives length at y=0
  plot(lengthdata,0,'go','LineWidth',2)   %plottar nedlsagsplatsen med gr?n ring
  
end
[U]=plotj(XYdata,fi);  %send XYdata for treatment och runge-kutta solution plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------Golden Section maximization-----------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F=polyfit(fi,lengthdata,2); %interpolation between angle och length polynomialvalue=2 
%interval
a=0;    
b=max_Angle;                      
%golden section properties
rg=(sqrt(5)-1)/2; 
qg=1-rg;  
x1=a+qg*(b-a);           
x2=a+rg*(b-a);
F1 = polyval(F,x1); %functional value for x1
F2 = polyval(F,x2); %functional value for x2
n=0;
%Golden section search
while ((abs(b-a)>=accuracy_golden_Section)) %condition: b-a is larger than accuracy
    if(F1>F2)
        b=x2;
        x2=x1;
        x1=a+qg*(b-a);
        F2=F1;
        F1=polyval(F,x1);   
    else
        a=x1;
        x1=x2;
        x2=a+rg*(b-a);
        F1=F2;
        F2=polyval(F,x2);
    end
n=n+1;    
end
fiOpti=x1;
angleOpti=fiOpti*180/pi;     % optimal angle
p=polyfit(fi,omega,2);       % interpolation fi and omega
omegaOpti=polyval(p,fiOpti); % calculation of angular velocity at optimal angle
V=L*omegaOpti;               % velocity  length*(rad/s)
x=L.*sin(fiOpti);            % x-position
Vy= V.*sin(fiOpti);          % velocity component in y-dir
y=2.5-L.*cos(fiOpti);        % y-position
Vx=V.*cos(fiOpti);           % velocity componen i x-dir
Y=[x, Vx, y, Vy];
Yopti= [];                   %savevector
    while Y(3) > 0
    f1=flight2(Y);
    f2=flight2(Y+h.*f1/2);
    f3=flight2(Y+h.*f2/2);
    f4=flight2(Y+h.*f3);
    Y=Y+h.*(f1+2*f2+2*f3+f4)/6;
    Yopti = [Yopti; Y(:,1) Y(:,3)];    
    end
plot(Yopti(:,1), Yopti(:,2),'r','Linewidth',3)
%linear interpolation between end points for good precision
% End points
x=[(Yopti(end-1,1)) Yopti(end,1)];
y=[(Yopti(end-1,2)) Yopti(end,2)];
plot(x,y,'mo')
line([0 2.5],[0 0])
plot(x,y,'-g','Linewidth',1)
k=(y(2)-y(1))/(x(2)-x(1));
m=y(1)- k*x(1);
max_Traj=m/(-k);
plot(max_Traj,0,'bo','LineWidth',1)
final_data=[fi*180/pi omega lengthdata];
error=Yopti(end,1) %error rungekutta
end

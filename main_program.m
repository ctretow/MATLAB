% ---- Platform: MATLAB              ---- % 
% ---- user: ctretow                 ---- %
% ---- Numerical Simulation          ---- %
% ---- Pendelum + Equation of motion ---- %
% ---- Differential equations        ---- %
% ---- Runge Kutta 4                 ---- %

%Main program
clc, clear all, close all
%constants
global L m k g
L=2.0;
m=17.0;
k=1.20;
g=9.81;
%setup
format short
int_Sign=-1;                 % changing sign
max_Angle=60*pi/180;         % max angle 
int_Val=[25*pi/180 0];       % initial value vector
fi=[];                       % save angle
omega=[];                    % save omega
xL=[];                       % save xL
yL=[];                       % save yL
n=1;                         % iterations
traj=[];                     % save trajectory
optimal_Angle=[];            % save optimal angle
error=[];              % save runge-kutta error 
for h=0.025:0.025:0.05; % step interval     
while abs(int_Val(1))<=max_Angle
    %RK4
    f1=fpend(int_Val);
    f2=fpend(int_Val+h.*f1/2);
    f3=fpend(int_Val+h.*f2/2);
    f4=fpend(int_Val+h.*f3);
    int_Val=int_Val+h.*(f1+2*f2+2*f3+f4)/6;
    if sign(int_Val(2)) ~= int_Sign; 
     int_Val(2) = int_Val(2)+0.6*sign(int_Val(2)); % change angular velocity at turning point
    end
    int_Sign = sign(int_Val(2)); % update sign
    omega    = [omega int_Val(2)]; % save angular velocity
    fi       = [fi int_Val(1)];    % save angle
%  Animation
%  axis([-3.5 3.5 0 4])
%  grid on 
%  hold on 
%  plot([0 xL], [2.5 yL], 'w', xL,  yL) 
%  xL=L*sin(int_Val(1)); %point in x-dir
%  yL=-L*cos(int_Val(1))+2.5; %point in y-dir
%  plot([0 xL], [2.5 yL], xL,  yL, 'ro')
%  pause(0.1)% animation
 n=n+1;
    if n > 2000 
        break %stops after 2000 iter
    end
end
fi2=fi(1800:end)';       %save stable angle values
omega2=omega(1800:end)'; %save stable velocity values
[data]=output_data(fi2,omega2) %send data to ouput_data function
[max_Traj, omegaOpti, fiOpti, final_data,accuracy_golden_Section,error,x1,x2,Fa]=opti(data,L,h,max_Angle) %send input_data to optimization function
traj=[traj max_Traj]; % save trajectory
error=[error; error]    % save error 
end
Optimal_length=traj'        % optimal length [m]
Optimal_angle=fiOpti*180/pi % optimal angle [deg]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------PLOTS-&-ERROR ESTIMATION-------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%plott length of traj with steplength
figure(2)
h=0.025:0.025:0.05;
plot(h,traj)
hold on
grid on
plot(h,traj,'mo') 
%Error estimation optimzation function
accuracy_golden_Section;
F1error=polyval(Fa,x1);
F2error=polyval(Fa,x2);
error_golden_Section=F2error-F1error
%Error estiomation runge kutta 
error_runge=error(1)-error(2)
%Error estimation Linear Interpolation
error_interp=Optimal_length(1)-Optimal_length(2)
%Total error
total_error=error_interp+error_runge+error_golden_Section
%PLOTS
%fi-omega
figure(3)
plot(fi,omega)
grid on
title('Phase')
xlabel('fi [rad]')
ylabel('omega [rad/s]') 
%fi2-omega2
figure(4)
plot(fi2,omega2)
grid on
title('Phase')
xlabel('fi [rad]')
ylabel('omega [rad/s]') 
%omega and fi
figure(5)
plot(omega)
grid on
hold on
plot(fi,'-r')
%omega2
figure(6)
plot(omega2,'b')
grid on
hold on
plot(fi2,'r')
grid on
%plot of polynomial for interpolation of angle and trajectory length
figure(7)
plot(final_data(:,1)*pi/180,final_data(:,3))
grid on
title('polyfit')
xlabel('fi')
ylabel('Traj length')
hold on
plot(final_data(:,1)*pi/180,final_data(:,3),'r*')
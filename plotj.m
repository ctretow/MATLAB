function [uvektor]=plotj(XYdata,fi)
uvektor=[];
dataspar=[];
XYdata1=XYdata(:,1);
XYdata2=XYdata(:,2);  
 for u=1:(length(XYdata)-1)
    if XYdata1(u)>XYdata1(u+1)
        uvektor=[uvektor u];
    end    
 end
for i=1:(length(fi)-2)
 a=XYdata1(uvektor(i)+1:1:uvektor(i+1));
 b=XYdata2(uvektor(i)+1:1:uvektor(i+1));
 c=XYdata1(1:uvektor);
 d=XYdata2(1:uvektor);
 e=XYdata1(uvektor(end)+1:length(XYdata1));
 f=XYdata2(uvektor(end)+1:length(XYdata1));
 hold on
 plot(a,b)
 hold on
 plot(c,d)
 hold on
 plot(e,f)
end 
end

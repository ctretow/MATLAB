function w = flight2(Y)
k=0.15;
g=9.82;
w=[Y(2), -k*Y(2)*sqrt(Y(2)^2+Y(4)^2), Y(4), -g-k*abs(Y(4))*sqrt(Y(2)^2+Y(4)^2)];
end


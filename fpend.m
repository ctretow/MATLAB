function fp = fpend(y)
global k m L g
fp = [y(2) -((k/m).*y(2)+(g/L).*sin(y(1)))];
end

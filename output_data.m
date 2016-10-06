%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Data processing of pendulum trajectory with highest speed------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data =output_data(fi2, omega2)
jvector= [];
for j=1:(length(fi2)-1)
    if fi2(j)*fi2(j+1)<0 % save the angle where sign is changed "[ minus*plus=minus]"
        jvector = [jvector j];
    end
end
aspar= [];
for f=1:length(fi2(jvector))
if fi2(jvector(f)) < 0
    aspar=[aspar f];
 end
end
start=(jvector(aspar(end))+1);
%end of data
uvector=[];
for u=1:(length(fi2)-1)
    if fi2(u)<fi2(u+1)
        uvector=[uvector u];
    end
end
fi2(uvector);
csave=[];
for c=1:length(fi2(uvector))
if fi2(uvector(c)) > 0
    csave=[csave c];
 end
end
s_end=uvector(csave(end)) 
%data interval
w=start:s_end;
%send data to be used in program
data=[fi2(w) omega2(w)];
end

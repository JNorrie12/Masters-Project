trial='13';
norm=400;
ends=importdata(strcat('50ends', trial, '.mat'));
[n,m]=size(ends);

times=zeros(n-norm-1,1);
timestart=zeros(n-norm-1,1);
i=0;
for e = 2:n
    if ends(e-1) < ends(e)
        times(e-i-1,1)=ends(e)-ends(e-1);
        timestart(e-i-1,1)=ends(e-1);
    elseif ends(e-1) > ends(e)
        i = i +1;
        disp(i);
    end
    
end

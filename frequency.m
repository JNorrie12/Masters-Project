v=[0, 3, 5, 7, 10, 13, 16, 20, 30, 50];
norm=[200, 200,200,400,400, 400, 365, 345, 428, 164];
T=5;
sensitivity = '10';

for j =1:T
    str= int2str(v(1,j));
    count=importdata(strcat(sensitivity ,'count', str, '.mat'));
    edges=importdata(strcat(sensitivity ,'edges', str, '.mat'));
   
    [m,N]=size(count);
    mean = count./norm(1,j);
    bin_middle = zeros(N,1);
 
    for e = 1:N
        bin_middle(e,1)=sqrt(edges(e,1)*edges(e+1,1));
    end
    
    xlabel('Generation');
    ylabel('Mean Rate of Transitions')
    loglog(bin_middle, mean, 'x');
    hold on;
    disp('BLOOP');
end

cummean= cumsum(mean);
figure
plot(bin_middle, cummean);
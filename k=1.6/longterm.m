
T=400;
trials=0;
population=zeros(10000,1);

for t = 1: T
    str = int2str(t);
    
    P=importdata( strcat(str , 'pop.txt'));
    [n,m]=size(P);
   if n ==10000 
    population=population + P(:,4);
    trials=trials +1;
    disp(t);
   end
end
population=population/trials;

plot(1:10000,population, 'o');
figure
plot(1:10000, population, 'o');
set(gca,'xscale','log');
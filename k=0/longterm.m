
T=255;

population=zeros(10000,1);
for t = 1: T
    str = int2str(t);
    
    P=importdata( strcat(str , 'pop.txt'));
    [n,m]=size(P);
   if n ==10000 
    population=population + P(:,4);
   
    disp(t);
   end
end
population=population/T;

plot(P(:,1),population, 'o');
figure
plot(P(:,1), population, 'o');
set(gca,'xscale','log');
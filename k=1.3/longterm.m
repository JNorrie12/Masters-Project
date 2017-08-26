
T=400;

population=zeros(10000,1);
for t = 1: T
    
   str = int2str(t);
    
   P=importdata( strcat(str , 'pop.txt'));
    
   
   population=population + P(:,4);
   
   disp(t);
   
end
population=population/T;

plot(P(:,1),population, 'o');
figure
plot(P(:,1), population, 'o');
set(gca,'xscale','log');
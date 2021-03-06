T=200; %Number of simulations

pop=zeros(10000, 3);
for j =1:T
    str= int2str(T);
    B=importdata(strcat(str ,'pop.txt'));
    
    pop(:,1) = pop(:,1) + B(:, 2);
    pop(:,2) = pop(:,2) + B(:, 3);
    pop(:,3) = pop(:,3) + B(:, 4); 
end

mean_pop= pop/T;
x=linspace(1,10000,10000);
plot(x ,mean_pop);
figure
xlabel('Generation');
ylabel('Population');
loglog(x, mean_pop);
hold on;
loglog([3,3],[150,500], 'k--');
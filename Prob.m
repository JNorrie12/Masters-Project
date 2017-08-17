p=0.2;
xi = log((1-p)/p);

k= linspace(xi, 5, 1000);

prob1= (1-xi./k)/2;

prob2 = 1-((1 + xi./k).^2)/4;

prob3=[0, 1, 2, 3, 4, 5];

prob4=[ 0, 0, 1/344, 42/422, 21/79, 176/400];
   
plot(k, prob1, 'b', k, prob2 , 'r');
hold on;
plot(prob3, prob4 ,'k--', 'Marker','o');

xlabel('k');
ylabel('Proportion');

figure 
loglog(prob3, prob4 ,'k--', 'Marker','o');
hold on;
loglog(prob3, 2*exp(prob3));
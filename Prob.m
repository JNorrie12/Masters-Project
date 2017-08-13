p=0.2;
xi = log((1-p)/p);

k= linspace(xi, 5, 1000);

prob1= (1-xi./k)/2;

prob2 = 1-((1 + xi./k).^2)/4;

plot(k, prob1, 'k', k, prob2 , 'r');

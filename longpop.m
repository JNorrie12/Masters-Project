population=zeros(10000,1);
v=[10, 13, 16, 20, 30,50];
colors= [0 ,0.4470, 0.7410; 0.85, 0.325, 0.0980; 0.9290, 0.6940, 0.1250;0.494,0.1840,0.5560; 0.4660, 0.6740, 0.1880;0.3010,0.7450,0.9330;
0.6350 ,0.0780 ,0.1840];
T=6;
x=1:10000;
f1 = figure;
f2 = figure;
f3 = figure;
f4 = figure;

crossover=zeros(T,1);
for t = 1: T
    str = int2str(v(1,t));
    P=importdata( strcat('population',str,'.mat'));
    
    difference=zeros(9999,1);
    for n=1:9999
        difference(n,1)=P(n+1,1)-P(n,1);
    end
    [A,I]=max(difference);
    crossover(t,1)=I;
    
    set(0, 'CurrentFigure', f1);
    cieling=2*(1.282857+v(1,t)/10)/0.007;
    
    plot([1,10000], [cieling, cieling], 'Color', colors(t,:), 'LineStyle', '--');
    hold on;
    plot(x, P(:,1), 'Color', colors(t,:) , 'Marker', 'o', 'Linestyle', 'none');    
    hold on;
    plot(I,P(I,1),'ko', 'MarkerFaceColor', 'k');
    hold on;

    ylim([200, 1900]);
    xlabel('Generation');
    ylabel('Average Population');
    set(gca,'xscale','log');
    
    set(0, 'CurrentFigure', f2);
    plot(x(1,2:end), difference, 'o');
    hold on;
    
    set(gca, 'xscale', 'log');
    
    set(0, 'CurrentFigure', f3);
    cieling=2*(1.282857+v(1,t)/10)/0.007;
    plot(x, (0.007*P(:,1)/2-1.282857)/(v(1,t)/10), 'Color', colors(t,:) , 'Marker', 'o', 'Linestyle', 'none');       
    hold on;
    plot(x, x./x, 'k--');
    hold on;
    ylim([0, 1.2]);
    ylabel('^{(\muN - 2\xi)}/_{2k}');
    xlabel('t');
    set(gca, 'xscale', 'log');
    
    set(0, 'CurrentFigure', f4);
    plot(x/(v(1,t).^(-0.92)), (0.007*P(:,1)/2-1.282857)/(v(1,t)/10), 'Color', colors(t,:) , 'Marker', 'o', 'Linestyle', 'none');    
    hold on;
%   plot(I/(v(1,t).^(-0.92)),(P(I,1)-2*1.282857/0.007)/v(1,t),'ko', 'MarkerFaceColor', 'k');
    hold on;
    q=linspace(10, 10.^6, 100);
    plot(q, q./q, 'k--');
    hold on;
    ylim([0,1.2]);
    xlim([10,10.^6]);
    ylabel('^{(\muN - 2\xi)}/_{2k}');
    xlabel('^{t}/_{k^{-0.92}}');
    set(gca, 'xscale', 'log');
end

fit=polyfit(log(v/10).', log(crossover), 1);
figure
loglog(v/10, crossover, 'k+', v/10, exp(fit(1,2))*(v/10).^fit(1,1), 'b--');
xlabel('k');
ylabel('t_c')
v=[3, 5, 7,10, 13, 16, 20, 30, 50];
norm=[200,200,400,400,400, 365, 345, 428, 224];
T=9;

% colors= [0 ,0.4470, 0.7410; 0.85, 0.325, 0.0980; 0.9290, 0.6940, 0.1250;0.494,0.1840,0.5560; 0.4660, 0.6740, 0.1880];
sensitivity ='10';

% const=zeroes(T,1);
power=zeros(T,1);
f1 = figure;
f2 = figure;
f3 = figure;
for k =1:T
    str= int2str(v(1,k));
    ends=importdata(strcat(sensitivity ,'ends', str, '.mat'));
%------------------------------------
    %LOG-BINNING%
    i=1; %Incemenet start
    a= 1.4; %Increment increase size e.g i_2=a*i, i_3=a*a*i, ...
    b= 1; %Original bin width

%-------------------------------------
    %Edges%
    N = floor(log(1-10000*(1-a)/b)/log(a)-1); %Number of increments
    edges=zeros(N + 2,1);
    bin_width=zeros(1, N+1);
    edges(1,1)=i;
    
    
    for j=1:N+1
        edges(j+1, 1)= edges(j,1) + b;
        bin_width(1, j) = b; 
        b=a*b;
    end
    [count, edge]=histcounts(ends, edges);
%------------------------------------
    %Bin_Middles%
    
    bin_middle = zeros(N+1,1);
    
    for e = 1:N+1
        bin_middle(e,1)=sqrt(edges(e,1)*edges(e+1,1));
    end
    
%------------------------------------
   mean=count./(bin_width*norm(1,k));
   
   %Variances%
%    variance=zeros(1, N+1);
%    counts=importdata(strcat(sensitivity ,'count', str, '.mat'));
%    for l=1:N+1
%         start=floor(edges(l,1));
%         finish=floor(edges(l+1,1));
%         variance(1, l)=var(counts(1, start:finish));
%    end
%    upper=mean+sqrt(variance);
%    lower=mean-sqrt(variance);
%   
%    errorbar(bin_middle,mean, lower, upper , 'o');
%    figure;
%-------------------------------------------------   
 

    first=find(~mean, 1, 'last');    
    for g=1:N-1
        if bin_middle(g,1)>100
            break
        end
    end
    %FITTING%    
    y= log(bin_middle);
    z=log(mean);
    coeff=polyfit(y(g:end,1).', z(1,g:end),1);
    if v(1,k)==50
        disp('B');
        coeff(1,1)=-0.910;
    end
    
    x=linspace(1,10000,10000);
    
    set(0, 'CurrentFigure', f1);
    
    xlabel('Generations')
    ylabel('Mean Rate of Transitions (Log-Binned)')
    
%     for l=1:N+1
%          loglog([bin_middle(l,1),bin_middle(l,1)],[lower(1,l),upper(1,l)], 'r-');
%         hold on;
%     end
 
%      loglog(x, exp(coeff(1,2))*x.^coeff(1,1), 'Color', colors(k,:));
%     loglog(x, exp(coeff(1,2))*x.^coeff(1,1));
%      hold on;
    power(k,1)=coeff(1,1);
    const(k,1)=coeff(1,2);
    loglog(bin_middle , mean); 
%     loglog(bin_middle , mean, 'x', 'Color', colors(k,:)); 
    hold on;
    xlim([10 10000]);
%----------------------------------------------------
    collapse=mean.'./(exp(coeff(1,2))*bin_middle.^(coeff(1,1)) );
    
    set(0, 'CurrentFigure', f2);
    loglog(bin_middle, collapse);
    hold on;
    
    coll2=1.2-collapse;
    set(0, 'CurrentFigure', f3);
    loglog(bin_middle./(exp(coeff(1,2))*bin_middle.^(coeff(1,1))), collapse);
    hold on;
end   
% v=cat(2,0,v);
% power=cat(1,0,power);

% figure;
q=linspace(0.2,6,100);
figure
fit=polyfit(log(v(1,1:T)/10), log(power+1).', 1);
plot(v(1,1:T)/10, power+1, 'k+');
hold on;
plot(q, exp(fit(1,2))*q.^fit(1,1), 'r--');
xlabel('k')
ylabel('\alpha(k)')
figure;
loglog(v(1,1:T)/10, power+1, 'k+');
hold on;
loglog(q, exp(fit(1,2))*q.^fit(1,1), 'r--');
xlabel('k');
ylabel('\alpha(k)');
figure;
plot(v(1,1:T)/10, power, 'k+');
hold on;
plot(q, exp(fit(1,2))*q.^fit(1,1)-1, 'r--', q, -q./q, 'k--');
xlabel('k')
ylabel('\gamma(k)')
ylim([-1.2, 0]);
% figure
% plot(v(1,1:T+1)/10, const, 'o');

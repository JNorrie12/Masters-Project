v=[3, 5, 7, 13];
norm=[200,200,400,400];
T=4;

sensitivity ='1';

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
    a= 1.3; %Increment increase size e.g i_2=a*i, i_3=a*a*i, ...
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
   variance=zeros(1, N+1);
   counts=importdata(strcat(sensitivity ,'count', str, '.mat'));
   for l=1:N+1
        start=floor(edges(l,1));
        finish=floor(edges(l+1,1));
        variance(1, l)=var(counts(1, start:finish));
   end
   upper=mean+sqrt(variance);
   lower=mean-sqrt(variance);
  
%    errorbar(bin_middle,mean, lower, upper , 'o');
%    figure;
%-------------------------------------------------   
    %FITTING%    
    y= log(bin_middle);
    z=log(mean);
    coeff=polyfit(y(9:end,1).', z(1,9:end),1);
    x=linspace(1,10000,10000);
    
    set(0, 'CurrentFigure', f1);
    
    xlabel('Generations')
    ylabel('Mean Rate of Transitions (Log-Binned)')
    
    for l=1:N+1
%         loglog([bin_middle(l,1),bin_middle(l,1)],[lower(1,l),upper(1,l)], 'r-');
%         hold on;
    end
 
    loglog(x, exp(coeff(1,2))*x.^coeff(1,1), 'k--');
    hold on;
    power(k,1)=coeff(1,1);
    loglog(bin_middle , mean, 'x'); 
    hold on;
%----------------------------------------------------
    collapse=mean.'./(exp(coeff(1,2))*bin_middle.^(coeff(1,1)) );
    
    set(0, 'CurrentFigure', f2);
    loglog(bin_middle, collapse, 'x');
    hold on;
    
    coll2=1.2-collapse;
    set(0, 'CurrentFigure', f3);
    loglog(bin_middle./(exp(coeff(1,2))*bin_middle.^(coeff(1,1))), collapse, 'x');
    hold on;
end   

figure;
plot(v/10, power+1);
figure;
loglog(v/10, power);

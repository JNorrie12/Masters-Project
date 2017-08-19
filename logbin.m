v=[3, 5, 7,10, 13, 16, 20, 30, 50];
norm=[200,200,400,400,400, 365, 345, 428, 224];
T=6;

% colors= [0 ,0.4470, 0.7410; 0.85, 0.325, 0.0980; 0.9290, 0.6940, 0.1250;0.494,0.1840,0.5560; 0.4660, 0.6740, 0.1880];
sensitivity ='10';

const=zeroes(T,1);
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
v=cat(2,0,v);
power=cat(1,0,power);

figure;
plot(v(1,1:T+1)/10, power+1, 'o');
figure;
plot(v(1,1:T+1)/10, power, 'o');
figure
plot(v(1,1:T+1)/10, const, 'o');

Although we can avoid having strategies with negative equilibra(safe) by having
\begin{equation}
	k < ln\left(\frac{(1-p_{kill})}{p_{kill}}\right) = \xi
\end{equation}
It is not correct to conversely say that one would expect extinctions for $k>\xi$. In fact as shown in the 3-d dimensional case, systems with higher interaction couplings are favoured, and therefore in the majority of cases unsafe strategies would not be chosen. To better understand extinction one must instead look at the proportion of unsafe stategies for a given k and $\xi$.
\\
The probability that a given non-zero entry of J, would produce and extinction is given by
\begin{equation}
	P(\xi + kx < 0) \text{\quad with \quad} x \sim U(-1,1)  
\end{equation}
Which is equivelant to 
\begin{align}
&=P\left(x < -\frac{\xi}{k}\right) \text{\quad with \quad} k \in [\xi, \infty) \\
&=\int_{-\infty}^{-\frac{\xi}{k}}f(x) \, dx \quad = \quad \int_{-1}^{-\frac{\xi}{k}} \frac{1}{2} \, dx \\
&=\frac{1}{2}\left(1- \frac{\xi}{k}\right) \quad k \in [\xi, \infty)
\end{align}
Therefore we see the proportion of unsafe J interactions is inversely proportional to k. \\
This effect is then amplified when considering the 2D strategies which constitute for the majoirty of the q-ESS's. We define a strategy $s(x_1, x_2)$ as 'safe' if both members of the interaction couplet are greater than that necessary for extinction to occur. The probability of  a given non-zero strategy being safe is therefore
\begin{align}
P\left(s(x_1,x_2) \quad safe \right) &= P\left(x_1 > -\frac{\xi}{k}\right)P\left(x_2 > -\frac{\xi}{k}\right) \quad \text{iid}\\[.7em]
&=\left[1 - P\left(x_1 < -\frac{\xi}{k}\right)\right]\left[1 - P\left(x_2 < -\frac{\xi}{k}\right)\right] \\[.7em]
&=\left[1 - \frac{1}{2}\left(1-\frac{\xi}{k}\right)\right]\left[1 - \frac{1}{2}\left(1-\frac{\xi}{k}\right)\right]\\[.7em]
&= \frac{1}{4}\left(1+\frac{\xi}{k}\right)^2 \quad k \in [\xi, \infty)
\end{align}
Since this is a smooth function, we would also expect the number of extinctions for a given $k$ to act smoothly, rather then $k=\xi$ being a hard cut-off. Tis is indeed what we see experimentally. 
\begin{figure}[H]
	\centering
	\includegraphics[width=.7\textwidth]{extinction.png}
	\caption{Blue shows the proportion of unsafe J, descirbed by (64). Red shows the proportion of unsafe stategies, $1- P(s(x_1, x_2) \quad safe)$. The black points represent the proportion of trials which lead to extinction. The proportion of extinction for $k=2,3,4,5$ are $0.29\%$, $9.93\%$, $26.6\%$, $50.9\%$.  }
\end{figure}
Although the probability of extinction obviously follows have a very different dependence on k, it does help explain how extinction is not necessarily certain for $k>1.3$. Infact during trials of $k=1.6$, exctintion was never observed, and $k=2$ it was only observed once in 400 trials. This does allow us to experiement with higher k.\\

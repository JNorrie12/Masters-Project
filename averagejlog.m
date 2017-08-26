v=[0, 3,5, 7, 10, 13, 50];
T=7;
f1 = figure;
f2 = figure;
f3= figure;
mean=zeros(T,1);
for t=1:T
    
trial=int2str(v(1,t));

ends=importdata(strcat('10ends', trial, '.mat'));
couplings=importdata(strcat('10couplings',trial, '.mat'));
bin_width=10;
%------------------------------------
    %LOG-BINNING%
 i=1; %Incemenet start
 a= 1.2; %Increment increase size e.g i_2=a*i, i_3=a*a*i, ...
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
    
    bin_middle = zeros(N + 1,1);
for e = 1:N+1
    bin_middle(e,1)=sqrt(edges(e,1)*edges(e+1,1));
end

[count2, gede]=histcounts(ends, edges);


[A,I]=sort(ends);
sorted_couples=zeros(max(I),1);

for s=1:max(I)
    sorted_couples(s,1)=couplings(I(s,1),1);
end

histo=zeros(N+1,1);
negpos=zeros(N+1, 3);
for f=1:max(I)
    for e=1:N+1
        if (A(f) >= edges(e,1)) && (A(f) < edges(e+1,1))
           histo(e,1)=histo(e,1) + sorted_couples(f,1);

           if sorted_couples(f,1) > 0
               negpos(e,1)= negpos(e,1) + 1;
           elseif sorted_couples(f,1) < 0
               negpos(e,2)= negpos(e,2)+1;
           else
               negpos(e,3)=negpos(e,3) +1;
           end
           break
        end
            
    end
end



q=linspace(10,10000,10000);
for i=1:N+1
    if count2(1,i)==0
        count2(1,i)=1;
    end
end
histo=histo./(count2.');
negpos_norm=negpos(:,1)./(negpos(:,1)+negpos(:,2));

%-----------------------------------
set(0, 'CurrentFigure', f1);
loglog(bin_middle, histo);
hold on;
set(0, 'CurrentFigure', f2);
plot(bin_middle, histo);
hold on;
set(0, 'CurrentFigure', f3);
plot(bin_middle, negpos_norm);
hold on;

%-----------------------------------
for i=1:N+1
    if bin_middle(i,1) > 4000
        start=i;
        break
    end
end

mean(t,1)=sum(negpos_norm(start:end,1))/(N+2-start);

end
figure 
plot(v(1,1:T), mean, 'x');
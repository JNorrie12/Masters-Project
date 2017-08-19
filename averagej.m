trial='3';

ends=importdata(strcat('10ends', trial, '.mat'));
couplings=importdata(strcat('10couplings',trial, '.mat'));
bin_width=20;
%----------------------------
edges=zeros(10000/bin_width + 1,1);
edges(1,1)=0;
for j = 2:10000/bin_width + 1
   
    edges(j,1)=edges(j-1,1)+ bin_width;
end

    bin_middle = zeros(10000/bin_width,1);
for e = 1:10000/bin_width
    bin_middle(e,1)=sqrt(edges(e,1)*edges(e+1,1));
end

[count2, gede]=histcounts(ends, edges);


[A,I]=sort(ends);
sorted_couples=zeros(max(I),1);

for s=1:max(I)
    sorted_couples(s,1)=couplings(I(s,1),1);
end

histo=zeros(10000/bin_width,1);
negpos=zeros(10000/bin_width, 3);
for f=1:max(I)
    for e=1:10000/bin_width
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
for i=1:10000/bin_width
    if count2(1,i)==0
        count2(1,i)=1;
    end
end
histo=histo./(count2.');
% negpos(:,1)=negpos(:,1)./(count2.');
% negpos(:,2)=negpos(:,2)./(count2.');


%-----------------------------------
%Moving average
mov=zeros(10000/bin_width,3);
width=25;
side=(width-1)/2;

mov(1:side, 1)=histo(1:side, 1);
mov(1:side, 2)=negpos(1:side,1);
mov(1:side, 3)=negpos(1:side,2);
mov(1:side, 4)=negpos(1:side,3);
for i= side +1:10000/bin_width-side
 
    
    mov(i,1)=sum(histo(i-side:i+side))/width ;    
    mov(i,2)=sum(negpos(i-side:i+side, 1 ))/width;
    mov(i,3)=sum(negpos(i-side:i+side, 2 ))/width;
    mov(i,4)=sum(negpos(i-side:i+side, 3))/width;
    
end

% hold on;
% plot(bin_middle, histo);
% hold on;
% plot(bin_middle, mov(:,1), bin_middle, mov(:,2)-0.5);

plot(bin_middle, mov(:,2),bin_middle, mov(:,3), bin_middle, mov(:,4));
hold on;
plot(q,0*q./q, 'k--');
xlabel('Generations');
ylabel('Number of Transitons');
% plot(bin_middle, negpos(:,1)-0.5, q, 0*q./q, 'k--');
% xlim([0,2000]);
figure
loglog(bin_middle, mov(:,2)-mov(:,3), q, 3000*q.^(-1));
figure
plot(bin_middle, mov(:,2)./(mov(:,2)+mov(:,3)), q, 0.5*q./q, 'k--');
% xlim([0,5000]);
figure
loglog(bin_middle,histo+1.5);
hold on;
loglog(q,1.5*q./q, 'k--');
figure
plot(zeroes, zeroes./zeroes, 'x');
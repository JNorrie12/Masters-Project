%LOG-BINNING---------------------------------------------
i=1; %Incemenet start
a= 1.0001; %Incremenrnt increase size e.g i_2=a*i, i_3=a*a*i, ...
b= 10; %Original bin width
x = 10; %Sensitivity

N = floor(log(1-10000*(1-a)/b)/log(a)-1); %Number of increments
display(N);
edges=zeros(N + 2,1);
edges(1,1)=i;

for j=1:N
    edges(j+1, 1)= edges(j,1) + b;
    b=a*b;
end
edges(N+2,1)=10000;
disp(edges);

%Setting up------------------
events=[0]; 
% interaction=[0];

T = 74;
for t = 1: T
    
    str = int2str(t);
    
    S=importdata( strcat(str , 'species_fast.txt'));
    SP=importdata( strcat(str , 'seppop.txt'));
    J=importdata( strcat(str , 'mat.txt'));
    [n,m] = size(S);
        
    bool=false;
   [M1,I1]=max(SP(1,2:513));  

   for k =1:x:10000
        
        [M2,I2]=max(SP(k,2:513));
        
        
        if I1 ~= I2 && (bool==false)
            
            events=cat(1, events, k);
%             interaction = cat(1, interaction, 0);
            bool = true; 
        end
        
        if I1 == I2 && (bool==true)
            bool = false;
%              interaction(end,1) = J(I1,J1+256)+J(J1+256,I1);
%             disp(J(I1, J1+256)+J(J1+256, I1));
%             disp(I1);
%             disp(J1+256);

        end
     
        I1 = I2;
        M1 = M2;
        
   end
% if size(events) ~= size(interaction);
%     disp('ERROR');
%     disp(t);
disp(t);
end
disp(events);
[count,edge]=histcounts(events, edges);

[x,y]=size(events);

normcount = count/x; %Normalise
meancount = count/T; %Mean

bin_middle = zeros(N+1,1);
for e = 1:N+1
    bin_middle(e,1)=sqrt(edges(e,1)*edges(e+1,1));
end
plot(bin_middle, meancount);
figure
loglog(bin_middle, normcount, 'x');
cumnorm= cumsum(normcount);
figure
plot(bin_middle, cumnorm);
% figure 
% plot(events, interaction, 'b--x');
% x= linspace(0,10000, 10000);
% loglog(x,log(x));
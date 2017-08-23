x=10; %Sensitivity
%----------------------------
edges=zeros(10001,1);
for j = 1:10001
   
    edges(j,1)=j;
end

%Setting up------------------
events=[0]; 
ends = [0];
T = 400;
for t = 1: T
    
   str = int2str(t);
    
   SP=importdata( strcat(str , 'seppop.txt'));
    
%    [n,m] = size(S);
        
   bool=false;
   [M1,I1]=max(SP(1,2:257));
   [N1,J1]=max(SP(1,258:513));  
   
   for k =1:x:10000
        
        [M2,I2]=max(SP(k,2:257));
        [N2,J2]=max(SP(k,258:513));
        
        
        if (I1 ~= I2 || J1 ~= J2) && (bool==false)         
%             events=cat(1, events, k);
            bool = true; 
        end
        
        if (I1 == I2 && J1 == J2) && (bool==true)
            bool = false;
            ends=cat(1,ends, k);
        end
     
        I1 = I2;
        M1 = M2;
        J1 = J2;
        N1 = N2;
        
   end
disp(t);
end

[count,edge]=histcounts(events, edges);
[count2, gede]=histcounts(ends, edges);

normcount = count2/x; %Normalise
meancount = count2/T; %Mean

bin_middle = zeros(10000,1);
for e = 1:10000
    bin_middle(e,1)=sqrt(edges(e,1)*edges(e+1,1));
end


plot(bin_middle, meancount);
figure
loglog(bin_middle, meancount, 'x');
cummean= cumsum(meancount);
figure
plot(bin_middle, cummean);

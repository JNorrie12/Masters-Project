x=10; %Sensitivity
z= 0.05; %Threshold
bin_width=100;
%----------------------------
edges=zeros(10000/bin_width + 1,1);
edges(1,1)=0;
for j = 2:10000/bin_width + 1
   
    edges(j,1)=edges(j-1,1)+ bin_width;
end

%Setting up------------------
events=[]; 
ends = [];
couplings=[];
w=0;
zeroes=[];
T = 400;
for t = 1: T
   str = int2str(t);
    
   SP=importdata( strcat(str , 'seppop.txt'));
   J=importdata( strcat(str, 'mat.txt'));
    
   [n,m] = size(SP);
        
   bool=false;
   [M1,I1]=max(SP(1,2:257));
   [N1,J1]=max(SP(1,258:513));  
   
   start=zeros(2,1);
   pop=zeros(2,1);
   for k =1:x:n
        
        [M2,I2]=max(SP(k,2:257));
        [N2,J2]=max(SP(k,258:513));
        
        if (I1 ~= I2 || J1 ~= J2) && (bool==false)         
            start(1,1)=1 + I1;
            start(2,1)=257 + J1;
            
            bool = true; 
        end
        
        if (I1 == I2 && J1 == J2) && (bool==true)
            bool = false;
            
            pop(1,1) =sum(SP(k,2:257));
            pop(2,1) =sum(SP(k,258:513));
            
            if (SP(k,start(1,1))< pop(1,1)*z) || (SP(k,start(2,1))< pop(2,1)*z)
                %coupling
                w=J(I2, 256 + J2) + J(256 + J2, I2)- J(start(1,1)-1, start(2,1)-1)-J(start(2,1)-1, start(1,1)-1) ; %No need for I1-2, since I1 is in SP(2:257)
                couplings=cat(1,couplings, w);
                if J(I2, 256 + J2)==0 || J(256 + J2, I2)==0
                zeroes=cat(1,zeroes, k);
                end
                
                ends=cat(1,ends, k);
            end
        end
     
        I1 = I2;
        M1 = M2;
        J1 = J2;
        N1 = N2;
        
   end
disp(t);
end

[count2, gede]=histcounts(ends, edges);
 
     normcount = count2/x; %Normalise
     meancount = count2/T; %Mean

    bin_middle = zeros(10000/bin_width,1);
for e = 1:10000/bin_width
    bin_middle(e,1)=sqrt(edges(e,1)*edges(e+1,1));
end

[A,I]=sort(ends);
sorted_couples=zeros(max(I),1);

for s=1:max(I)
    sorted_couples(s,1)=couplings(I(s,1),1);
end

histo=zeros(10000/bin_width,1);
for f=1:max(I)
    for e=1:10000/bin_width
        if (A(f) >= edges(e,1)) && (A(f) < edges(e+1,1))
           disp(edges(e,1));
           disp(A(f));
           disp(edges(e+1,1));
           histo(e,1)=histo(e,1) + sorted_couples(f,1);
           break
        end
            
    end
end
histo=histo./(count2.');
plot(bin_middle, histo);
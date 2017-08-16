x=100; %Sensitivity

%Setting up------------------
events=[0]; 
ends = [0];
start=zeros(2,1);
pop=zeros(2,1);
w=0;

t = 7;

str = int2str(t);
    
SP=importdata( strcat(str , 'seppop.txt'));
B=importdata(strcat(str, 'pop.txt'));
   
x1= B(:, 1);
x2= B(:, 2);
x3= B(:, 3);
x4= B(:, 4);
       
bool=false;
[M1,I1]=max(SP(1,2:257));
[N1,J1]=max(SP(1,258:513));  
   
for k =1:x:10000
        
     [M2,I2]=max(SP(k,2:257));
     [N2,J2]=max(SP(k,258:513));
        
        
     if (I1 ~= I2 || J1 ~= J2) && (bool==false)            
         start(1,1)=1 + I1;
         start(2,1)=257 + J1;
         bool = true; 
           
         %coupling
         w = -J(I1, 256 + J1)-J(256 + J1, I1);         
 
     end
        
     if (I1 == I2 && J1 == J2) && (bool==true)
         bool = false;
         pop(1,1) =sum(SP(k,2:257));
         pop(2,1) =sum(SP(k,258:513));
         
         if (SP(k,start(1,1))< pop(1,1)*z) || (SP(k,start(2,1))< pop(2,1)*z)
            w=w + J(I2, 256 + J2) + J(256 + J2, I2); 
            ends=cat(1,ends, k);
         end
     end
     
     I1 = I2;     
     M1 = M2;
     J1 = J2;
     N1 = N2;
        
end

plot(x1, x2, 'b', x1, x3, 'r', x1, x4, 'g');
hold on;
plot([ends, ends],[800, 0], 'k--');


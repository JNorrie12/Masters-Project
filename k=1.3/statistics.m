%Transition Detection Algorithm
%Parameters.
x=10; %Sensitivity.
z= 0.05; %Threshold.

%Set up outputs.
ends = []; %Transtion ending points.
couplings=[]; %Coupling difference per transition, 'd'.
T = 400; %Number of trials.

w=0;

for t = 1: T
   %Importing data
   str = int2str(t);
   SP=importdata( strcat(str , 'seppop.txt'));
   J=importdata( strcat(str, 'mat.txt'));
   
   [n,m] = size(SP);
   %Setting logic statement 
   bool=false;
   %Finding dominant species.
   [M1,I1]=max(SP(1,2:257));
   [N1,J1]=max(SP(1,258:513));  
   
   start=zeros(2,1);%Records coupling before transition.
   pop=zeros(2,1);%Records population for threshold inequality.
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
            
            %Record populations.
            pop(1,1) =sum(SP(k,2:257));
            pop(2,1) =sum(SP(k,258:513));
            
            if (SP(k,start(1,1))< pop(1,1)*z) || ...
                    (SP(k,start(2,1))< pop(2,1)*z)
                %Difference taken.
                w=J(I2, 256 + J2) + J(256 + J2, I2) ...
                    -(J(start(1,1)-1, start(2,1)-1)...
                        + J(start(2,1)-1, start(1,1)-1));
                
                couplings=cat(1,couplings, w); %Difference added.
                ends=cat(1,ends, k); %Event added.
            end
        end
     
        %Setting dominant species for the next iteration.
        I1 = I2;
        M1 = M2;
        J1 = J2;
        N1 = N2;
        
   end
disp(t);
end
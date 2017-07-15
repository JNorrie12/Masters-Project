S=importdata('19species_fast.txt');
P=importdata('19pop.txt');
SP=importdata('19seppop.txt');
J=importdata('19mat.txt');
[n,m] = size(S);

x = 50;

BB=zeros(1,4);
B=[1, J(S(2,1)+1, S(2,2)+1), J(S(2,2)+1, S(2,1)+1),  J(S(2,1)+1,S(2,2)+1) + J(S(2,2)+1,S(2,1)+1) ]; 
BB = cat(1,BB, B);

for i = 2:x:n-x-2  
   A = S(i,1:2)-S(i+x,1:2);
   
   if A ~=0
       j = i+ x;
       B=[j, J(S(j,1)+1, S(j,2)+1), J(S(j,2)+1,S(j,1)+1),  J(S(j,1)+1,S(j,2)+1) + J(S(j,2)+1,S(j,1)+1) ];

       BB = cat(1,BB, B);  
   end
end
BB(1,:)=BB(2,:);

plot(BB(:,1),BB(:,4));
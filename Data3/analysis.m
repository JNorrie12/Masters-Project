
%--------------------------------------------
J=importdata('16mat.txt');
B=importdata('16pop.txt');
x1= B(:, 1);
x2= B(:, 2);
x3= B(:, 3);
x4= B(:, 4);

plot(x1, x2, 'b', x1, x3, 'r', x1, x4, 'g');
xlabel('Generations');
ylabel('Population')
%--------------------------------------------
A=importdata('16seppop.txt');
[n,m]=size(A);


D=[0];
C=[0];
E=[0];
F=[0];

CCom1= zeros(n,1);
CCom2= zeros(n,1);
x=(m+1)/2;
for i = 1:n
   count=0;
   Com1=0;
%    h = 0.055*x2(i,1);
%    g = 0.05*x3(i,1);
   for j= 2:x
       if A(i,j) > 0
            D=cat(1, D, j-2);
            count = count + 1;
           %Centre of mass
            Com1 = Com1 + (j-2)*A(i,j);
           %----------------------
       end
   end
   
   X = i*ones(count,1);
   C=cat(1,C,X);
   count2=0;
   Com2=0;
   
   %Centre of mass 
   CCom1(i, 1)= Com1/x2(i,1);
   %----------------
   for k= x+1:m
       if A(i,k) > 0
            F=cat(1, F, (k-2));
            count2 = count2 + 1;
           %Centre of mass
            Com2 = Com2 + (k-2)*A(i,k);
           %--------------------
       end 
   end
   
   Y = i*ones(count2,1);
   E =cat(1,E,Y);
   
   %Centre of mass
   CCom2(i,1)= Com2/x3(i,1);
   
end
display("BOOP");
figure
scatter(C, D, '.', 'b' );
hold on;
scatter(E, F, '.', 'r');
hold on;
plot(x1, CCom1,'g' , x1, CCom2, 'g');
xlabel('Generation');
ylabel('Species Label');

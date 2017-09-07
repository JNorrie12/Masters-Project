J=importdata('4mat.txt');

display(J(378, 68)); %302 -> 115
display(J(346, 68)); %115 -> 302

display(J(303, 195));
display(J(496, 195));


%--------------------------------------------
J=importdata('4mat.txt');
B=importdata('4pop.txt');
x1= B(2050:2300, 1);
x2= B(:, 2);
x3= B(:, 3);
x4= B(:, 4);

% plot(x1, x2, 'b', x1, x3, 'r', x1, x4, 'g');
% xlabel('Generations');
% ylabel('Population')
%--------------------------------------------
A=importdata('4seppop.txt');
[n,m]=size(A);


D=[0];
C=[0];
E=[0];
F=[0];

CCom1= zeros(200,1);
CCom2= zeros(200,1);
x=(m+1)/2;
for i = 2050:2300
   count=0;
   Com1=0;
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
   CCom1(i-2049, 1)= Com1/x2(i,1);
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
   CCom2(i-2049,1)= Com2/x3(i,1);
   
end

display("BOOP");
figure
scatter(C, D, '.', 'b' );
hold on;
scatter(E, F, '.', 'r');
hold on;
plot(x1, CCom1,'g' , x1, CCom2, 'g');
hold on;
plot([2119,2119],[0,600], 'k--');
hold on;
plot([2127,2127],[0,600], 'k--');
hold on;
plot([2146,2146],[0,600], 'k--');
hold on;
plot([2208,2208],[0,600], 'k--');
hold on;
xlabel('Generation');
xlim([2050,2300]);
ylabel('Species Label');
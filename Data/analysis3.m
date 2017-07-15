J=importdata('4mat.txt');
[n,m] = size(J);
%-------------------------------------------------
AA = [0,0,0];

for i = 1:n
    for j =1:m
        if J(i,j) >= 0.99
            A=[i,j,1+J(i,j)];
            AA =cat(1,AA,A);        
        end
    end
    % A = i*ones(m); 
   %  B = 1:m;
  %   AA = cat(1,AA,A);
%     BB = cat(1,BB,B);
 %    JJ = cat(1, JJ, J(i,:) );
%    for j = 1: m 
%          scatter(n,m,[],J(n,m));
%          hold on;
end
scatter(AA(:,1), AA(:,2),[],AA(:,3),'.');
%-------------------------------------------------
BB = zeros(n, 6);

for i= 1:n
    BB(i, 1) = sum(J(i,:));
    BB(i, 2) = sum(J(:,i));
    BB(i, 3) = BB(i,1) + BB(i, 2);
    for j= 1:m
        if J(i,j) ~= 0 
            BB(i, 3) = BB(i, 3) + 1;
        end
        
        if J(i,j) > 0 
            BB(i,4) = BB(i,4) +1;
        end
          
            
    end
end
figure;
x = 1:n;
scatter(x , BB(:,1));
figure;
scatter(x, BB(:,3));
figure;
scatter(x, BB(:,4));
display(BB(302,4));
%display(BB(116,1));
%display(BB(116,2));
%display(BB(303, 2));
%display(BB(302, 4));
%---------------------------------------------------
% a = tabulate(BB(:,4));
% scatter(a(:,1),a(:,2));
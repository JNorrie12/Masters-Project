for t = 1: 16
    
    str = int2str(t);
    
    
    S=importdata( strcat(str , 'species_fast.txt'));
    P=importdata( strcat(str , 'pop.txt'));
    SP=importdata( strcat(str , 'seppop.txt'));
    J=importdata( strcat(str , 'mat.txt'));
    [n,m] = size(S);

    x = 300;
    
    BB=zeros(1,4);
    B=[1, J(S(2,1)+1, S(2,2)+1), J(S(2,2)+1, S(2,1)+1),  J(S(2,1)+1,S(2,2)+1) + J(S(2,2)+1,S(2,1)+1) ]; 
    BB = cat(1,BB, B);

    for i = 2:x:n-x-2  
       A = S(i,1:2)-S(i+x,1:2);

%        if A ==0
           j = i;
           B=[j, J(S(j,1)+1, S(j,2)+1), J(S(j,2)+1,S(j,1)+1),  J(S(j,1)+1,S(j,2)+1) + J(S(j,2)+1,S(j,1)+1) ];

           BB = cat(1,BB, B);  
%        end
    end
    BB(1,:)=BB(2,:);

    loglog(BB(:,1),BB(:,4), 'bx');
    hold on;
end
xlabel('Generation');
ylabel('Interaction couplet of dominant species');

T=1;
for t = 1: T
    
    str = int2str(t);
    
    
    S=importdata( strcat(str , 'species_fast.txt'));
    P=importdata( strcat(str , 'pop.txt'));
    SP=importdata( strcat(str , 'seppop.txt'));
    J=importdata( strcat(str , 'mat.txt'));
    
    
    [n,m] = size(S);

    k = i;
    BB=zeros(N,4);
    mean(1,1) = mean(1,1) + BB(1,4);
    l=0;
    while k <10000 
        disp(S(k, 1:2));
        disp(S(k+x, 1:2));
        A = S(k,1:2)-S(k+x,1:2);
            l = l+1;
            j = k+ x;
            BB(l,:) = [j, J(S(j,1)+1, S(j,2)+1), J(S(j,2)+1,S(j,1)+1),  J(S(j,1)+1,S(j,2)+1) + J(S(j,2)+1,S(j,1)+1) ];
            mean(l,1) = mean(l,1) + BB(l,4);
        k= k*a;
    end
    
    BB(l + 1,:)=[10000, J(S(10000,1)+1, S(10000,2)+1), J(S(10000,2)+1,S(10000,1)+1),  J(S(10000,1)+1,S(10000,2)+1) + J(S(j,2)+1,S(j,1)+1) ];
    
    mean(l + 1, 1 ) = mean(l + 1, 1) + BB(l + 1,4);
    if l+1 ~= N
        disp("ERROR");
    end
    
    loglog(BB(1:12,1),BB(1:12,4),'bx');
    hold on;
end
mean = mean/T;
loglog(BB(1:12,1), mean(1:12,1), 'k-x');
xlabel('Generation');
ylabel('Interaction couplet of dominant species');
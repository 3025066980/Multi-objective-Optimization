function f = initialize_variables(N, M, V, min_range, max_range, tasknum, nodenum)

%% function f = initialize_variables(N, M, V, min_tange, max_range) 
%��ʼ��Ⱦɫ��

% N - ��Ⱥ��С
% M - Ŀ�꺯������
% V - ���߱�������
% min_range 
% max_range 

min = min_range;
max = max_range;
taskn = tasknum;
noden = nodenum;



K = M + V;    %  ���߱��� + Ŀ�꺯��ֵ

%% Initialize each chromosome   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ��ÿ��Ⱦɫ�壨���򣬿�����Ҫ�޸ĵĵط���
% For each chromosome perform the following (N is the population size)
for i = 1 : N %��Ⱥ��С
    
    s = 0;
    s0 = 0;
    
    for j = 1 : noden %�ڵ���٣�Ҳ����kֵ�ĸ��������������j���ڵ���ٸ�����
        g(i,j) = min(j) + round((max(j) - min(j))*rand(1));
        s = s + g(i,j);
    end
    
    for j = 1 : noden
        f(i,j) = floor((g(i,j) * taskn ) / s);
        s0 = s0 + f(i,j);
    end
    if s0 ~= taskn
        f(i,noden) = f(i, noden) + taskn - s0;%%
    end
    
 
    for j = noden + 1 : V
        f(i,j) = min(j) + round((max(j) - min(j))*rand(1));
    end 
    
    % f(i,:)ȡ����һ������    f(i,V+1:K) 
    f(i,V + 1: K) = evaluate_objective(f(i,:), M, V, noden);  
    
end

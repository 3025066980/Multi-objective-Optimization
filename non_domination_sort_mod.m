function f = non_domination_sort_mod(x, M, V)

%% function f = non_domination_sort_mod(x, M, V)

[N, m] = size(x);  % �������о��߱�����ɵ������������� N��m�� ��N����Ⱥ����
clear m

% Initialize the front number to 1.
front = 1;


F(front).f = [];
individual = [];

%% Non-Dominated sort. 
%   Initialize Sp = [].��������p֧��ļ��ϣ� 
%   Initialize np = 0.��֧�����p�ļ���Ԫ�ظ����� 

for i = 1 : N  %��Ⱥ����
    % ��ʼ��ÿһ����Ⱥ�����֧���ϵ
    individual(i).n = 0; %  ֧��ø���ĸ���������ʼΪ0
    individual(i).p = []; % �ø�����֧��ĸ��弯��
    
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M %����Ŀ�꺯��ֵ
            if (x(i,V + k) < x(j,V + k))
                dom_less = dom_less + 1;
            elseif (x(i,V + k) == x(j,V + k))
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M  %% ֧�䵱ǰ����ĸ������ + 1
            individual(i).n = individual(i).n + 1;

        elseif dom_more == 0 && dom_equal ~= M  %% ����ǰ����֧��ĸ��弯��
            individual(i).p = [individual(i).p j]; %% ��¼����λ��
        end
    end   
    if individual(i).n == 0
        x(i,M + V + 1) = 1;
        F(front).f = [F(front).f i]; %% ��¼����
    end
end
% Find the subsequent fronts
while ~isempty(F(front).f)
   Q = [];
   for i = 1 : length(F(front).f)
       if ~isempty(individual(F(front).f(i)).p)
        	for j = 1 : length(individual(F(front).f(i)).p)
            	individual(individual(F(front).f(i)).p(j)).n = ...
                	individual(individual(F(front).f(i)).p(j)).n - 1;
        	   	if individual(individual(F(front).f(i)).p(j)).n == 0
               		x(individual(F(front).f(i)).p(j),M + V + 1) = ...
                        front + 1;
                    Q = [Q individual(F(front).f(i)).p(j)];
                end
            end
       end
   end
   front =  front + 1;
   F(front).f = Q;
end

[temp,index_of_fronts] = sort(x(:,M + V + 1));
for i = 1 : length(index_of_fronts)
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);
end
current_index = 0;  %%%%% ��ǰ����Ϊ0

%% Crowding distance

% Find the crowding distance for each individual in each front
%%% һ������5��֧���� ����ÿһ��֧�����ÿ�����壬��Ҫ����ӵ���ȵļ��㣬�Ա��߽���ʹ��
for front = 1 : (length(F) - 1)   %% F�б�������ĸ����������ĸ�֧����front
%    objective = [];
    distance = 0;
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length((F(front).f)-1)
        y(i,:) = sorted_based_on_front(current_index + i,:);
    end
    current_index = current_index + i;
    % Sort each individual based on the objective
    sorted_based_on_objective = [];
    for i = 1 : M
        [sorted_based_on_objective, index_of_objectives] = ...
            sort(y(:,V + i));
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = ...
            sorted_based_on_objective(length(index_of_objectives), V + i);
        f_min = sorted_based_on_objective(1, V + i);
        y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i)...
            = Inf;
        y(index_of_objectives(1),M + V + 1 + i) = Inf;
         for j = 2 : length(index_of_objectives) - 1
            next_obj  = sorted_based_on_objective(j + 1,V + i);
            previous_obj  = sorted_based_on_objective(j - 1,V + i);
            if (f_max - f_min == 0)
                y(index_of_objectives(j),M + V + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + V + 1 + i) = ...
                     (next_obj - previous_obj)/(f_max - f_min);
            end
         end
    end
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);
    end
    y(:,M + V + 2) = distance;
    y = y(:,1 : M + V + 2);
    z(previous_index:current_index,:) = y;
end
f = z();

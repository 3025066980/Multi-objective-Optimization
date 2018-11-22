function f  = genetic_operator(parent_chromosome, M, V, mu, mum, l_limit, u_limit, nodenum)

%% function f  = genetic_operator(parent_chromosome, M, V, mu, mum, l_limit, u_limit)

% ���Ŵ�������������������ģ�

% parent_chromosome -����ѡ���10�����������ڲ����Ӵ���
% M - Ŀ�꺯������
% V - ���߱�������
% mu - ����ֲ�ָ��
% mum - ����ֲ�ָ��
% l_limit - a vector of lower limit for the corresponding decsion variables
%
% u_limit - a vector of upper limit for the corresponding decsion variables
%
%�Ŵ����ӽ����ǲ������߱���


[N,m] = size(parent_chromosome);

clear m
p = 1;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flags used to set if crossover and mutation were actually performed. 
was_crossover = 0;
was_mutation = 0;


for i = 1 : N %%%%������Ⱥ����ѡ������10��������
    % With 90 % probability perform crossover ������ĸ�����0.9��
    if rand(1) < 0.9
        % Initialize the children to be null vector.
        child_1 = [];
        child_2 = [];
        % Select the first parent
        parent_1 = round(N*rand(1));
        if parent_1 < 1
            parent_1 = 1;
        end
        % Select the second parent
        parent_2 = round(N*rand(1));
        if parent_2 < 1
            parent_2 = 1;
        end         %%%��10��������Ⱥ��ѡ��2��������׼�������Ӵ�
        % Make sure both the parents are not the same. 
        while isequal(parent_chromosome(parent_1,:),parent_chromosome(parent_2,:))
            parent_2 = round(N*rand(1));
            if parent_2 < 1
                parent_2 = 1;
            end
        end
        % Get the chromosome information for each randomnly selected
        % parents
        parent_1 = parent_chromosome(parent_1,:);
        parent_2 = parent_chromosome(parent_2,:);  %%%ȡ��������ѡ������������Ϣ���������߱���������ֵ��rankֵ�Լ�distanceֵ
        % Perform corssover for each decision variable in the chromosome.
        % ����Ⱦɫ���еľ��߱�������ʼ���н���
        for j = 1 : V %%���߱�����1��20
            % SBX (Simulated Binary Crossover).
            % For more information about SBX refer the enclosed pdf file.
            % Generate a random number
            u(j) = rand(1);
            if u(j) <= 0.5
                bq(j) = (2*u(j))^(1/(mu+1));
            else
                bq(j) = (1/(2*(1 - u(j))))^(1/(mu+1));
            end
            % Generate the jth element of first child ������һ�����ӵĵ�һ��Ԫ��
            %%Ҳ���ǶԸ�����������ĵ�һ�����߱������н��棬������һ���Ӵ��ĵ�һ�����߱���
            child_1(j) = ...
                round(0.5*(((1 + bq(j))*parent_1(j)) + (1 - bq(j))*parent_2(j)));
            
            % Generate the jth element of second child
            child_2(j) = ...
                round(0.5*(((1 - bq(j))*parent_1(j)) + (1 + bq(j))*parent_2(j)));
            % Make sure that the generated element is within the specified
            % decision space else set it to the appropriate extrema.
            %%ȷ�������ľ��߱�����ֵ���ᳬ��Ԥ�õķ�Χ��
            if child_1(j) > u_limit(j)
                child_1(j) = u_limit(j);
            elseif child_1(j) < l_limit(j)
                child_1(j) = l_limit(j);
            end
            if child_2(j) > u_limit(j)
                child_2(j) = u_limit(j);
            elseif child_2(j) < l_limit(j)
                child_2(j) = l_limit(j);
            end
        end
        % Evaluate the objective function for the offsprings and as before
        % concatenate the offspring chromosome with objective value.
        child_1(:,V + 1: M + V) = evaluate_objective(child_1, M, V, nodenum);
        child_2(:,V + 1: M + V) = evaluate_objective(child_2, M, V, nodenum);
        % Set the crossover flag. When crossover is performed two children
        % are generate, while when mutation is performed only only child is
        % generated. �����Ӵ������Ѿ�������
        was_crossover = 1;
        was_mutation = 0;
    % With 10 % probability perform mutation. Mutation is based on
    % polynomial mutation. 
    else
        % Select at random the parent.
        parent_3 = round(N*rand(1));
        if parent_3 < 1
            parent_3 = 1;
        end
        % Get the chromosome information for the randomnly selected parent.
        child_3 = parent_chromosome(parent_3,:);
        % Perform mutation on eact element of the selected parent.
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���¼����޸�
        for j = 1 : V %%%%�������еľ��߱���
           r(j) = rand(1);
           if r(j) < 0.5
               delta(j) = (2*r(j))^(1/(mum+1)) - 1;
           else
               delta(j) = 1 - (2*(1 - r(j)))^(1/(mum+1));
           end
           % Generate the corresponding child element.
           child_3(j) = child_3(j) + round(delta(j));
           % Make sure that the generated element is within the decision
           % space.
           if child_3(j) > u_limit(j)
               child_3(j) = u_limit(j);
           elseif child_3(j) < l_limit(j)
               child_3(j) = l_limit(j);
           end
        end
        % Evaluate the objective function for the offspring and as before
        % concatenate the offspring chromosome with objective value.    
        child_3(:,V + 1: M + V) = evaluate_objective(child_3, M, V, nodenum);
        % Set the mutation flag
        was_mutation = 1;
        was_crossover = 0;
    end
    % Keep proper count and appropriately fill the child variable with all
    % the generated children for the particular generation.
    if was_crossover
        child(p,:) = child_1;
        child(p+1,:) = child_2;
        was_cossover = 0;
        p = p + 2;
    elseif was_mutation
        child(p,:) = child_3(1,1 : M + V);
        was_mutation = 0;
        p = p + 1;
    end
end
f = child;

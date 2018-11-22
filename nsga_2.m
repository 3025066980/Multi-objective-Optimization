function nsga_2(pop,gen,tasknum0,nodenum0)

%% function nsga_2(pop,gen��tasknum0,nodenum0) 
% pop - ��Ⱥ����
% gen - �Ŵ�����
% tasknum0 - �������
% nodenum0 - �ڵ�
tic;
%% ������ 
if nargin < 4  
    error('NSGA-II: Please enter the population size and number of generations as input arguments.');
end

if isnumeric(pop) == 0 || isnumeric(gen) == 0 || isnumeric(tasknum0) == 0 || isnumeric(nodenum0) == 0   %�ж��������һ����
    error('Both input arguments pop��gen��tasknum and nodenum should be integer datatype');
end

if pop < 20
    error('Minimum population for running this function is 20');
end
if gen < 5
    error('Minimum number of generations is 5');
end
if tasknum0 < 50 || tasknum0 > 250
    error('Minimum number of task is 50 and Maximum number of task is 250');
end
if nodenum0 > 15 || nodenum0 < 5 
    error('Minimum number of node is 5 and Maximum number of node is 15');
end
%  �ֱ�������ȡ����
pop = round(pop);  
gen = round(gen);
tasknum = round(tasknum0);
nodenum = round(nodenum0);
%% Objective Function

[M, V, min_range, max_range] = objective_description_function(tasknum,nodenum);

%% Initialize the population

chromosome = initialize_variables(pop, M, V, min_range, max_range, tasknum, nodenum);


%% Sort the initialized population
%�������У�һ�д���rank��һ�д���ӵ�����룬Ȼ��׷����ÿһ��Ⱦɫ���������
chromosome = non_domination_sort_mod(chromosome, M, V);

%% Start the evolution process

for i = 1 : gen   % ��������˵50��
   
    pool = round(pop/2);
    tour = 2;
  
    parent_chromosome = tournament_selection(chromosome, pool, tour); 
    % Ⱦɫ���������������Ԫ�ر��õ�����һ����rankֵ���ڶ�����ӵ������
    %ѡ���˸���Ⱦɫ�壬һ��10��������rank�ȼ�����ͬrank�ȼ���ӵ��������ж����ƽ�����ѡ��Ľ��
   
    mu = 20;  %% ����ָ������ ��c 
    mum = 20; %% ����ָ������ ��m
    offspring_chromosome = ...
        genetic_operator(parent_chromosome, ...
        M, V, mu, mum, min_range, max_range, nodenum);

   %������ѡ�����ͽ��������Ӵ� 
    [main_pop,temp] = size(chromosome); %�����ܵ�Ⱦɫ�弸�м���
    [offspring_pop,temp] = size(offspring_chromosome); % �����Ӵ�Ⱦɫ�弸�м���
   
    clear temp
 
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = ...
        offspring_chromosome;    %M Ŀ�꺯��    V���߱���
 
   
    intermediate_chromosome = ...
        non_domination_sort_mod(intermediate_chromosome, M, V); 
    % Perform Selection
    %���溯�����ǽ��о�Ӣ���Ե�ʹ��
    chromosome = replace_chromosome(intermediate_chromosome, M, V, pop); 
    %if ~mod(i,100)  %%ÿ100����ʾһ�����е�������
        %clc
        %fprintf('%d generations completed\n',i);
    %end
end

   t = toc;
   
   fprintf('��������ʱ��Ϊ��%d\n',t);

%% Result

save solution.txt chromosome -ASCII

%% Visualize

if M == 2
    plot(chromosome(:,V + 1),chromosome(:,V + 2),'*');
     xlabel('�����������ʱ��');ylabel('���ؾ���ֵ');
end

    

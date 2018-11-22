function f = tournament_selection(chromosome, pool_size, tour_size)

%% function tournament_selection(chromosome, pool_size, tour_size) 

%% Tournament selection process

% Get the size of chromosome. The number of chromosome is not important
% while the number of elements in chromosome are important.
[pop, variables] = size(chromosome); %%%%%����Ⱦɫ����к��У�20�м�20����Ⱥ������7�м���ز���
% The peunltimate element contains the information about rank.
rank = variables - 1;  %%%�����ڶ���Ϊrank
% The last element contains information about crowding distance.
distance = variables;  %%% ������һ��Ϊӵ������

% Until the mating pool is filled, perform tournament selection
for i = 1 : pool_size %%%1��10
    % Select n individuals at random, where n = tour_size ��2
    for j = 1 : tour_size %%1��2
        % Select an individual at random
        candidate(j) = round(pop*rand(1)); %%��Ⱥ���� x ����� ȡ����
        % Make sure that the array starts from one. 
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1
            % Make sure that same candidate is not choosen.ͬ���ĺ�ѡ�߲���ѡ��
            while ~isempty(find(candidate(1 : j - 1) == candidate(j)))
                candidate(j) = round(pop*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;
                end
            end
        end
    end
    % Collect information about the selected candidates.
    for j = 1 : tour_size  %%%���ڴ���������
        c_obj_rank(j) = chromosome(candidate(j),rank);
        c_obj_distance(j) = chromosome(candidate(j),distance);
    end
    % Find the candidate with the least rank
    min_candidate = ...
        find(c_obj_rank == min(c_obj_rank));
    % If more than one candiate have the least rank then find the candidate
    % within that group having the maximum crowding distance.
    if length(min_candidate) ~= 1
        max_candidate = ...
        find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        % If a few individuals have the least rank and have maximum crowding
        % distance, select only one individual (not at random). 
        if length(max_candidate) ~= 1
            max_candidate = max_candidate(1);
        end
        % Add the selected individual to the mating pool
        f(i,:) = chromosome(candidate(min_candidate(max_candidate)),:);
    else
        % Add the selected individual to the mating pool
        f(i,:) = chromosome(candidate(min_candidate(1)),:);
    end
end

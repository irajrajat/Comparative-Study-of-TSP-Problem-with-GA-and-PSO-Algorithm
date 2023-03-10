
function out = pso(problem,params)


   
%% Problem Definition

    CostFunction = @(x, y) TSPcostFunction(x, y); % Cost Function

    citiesNumber = problem.citiesNumber; % Number of TSP cities

    PositionSize = [citiesNumber 2]; % Size of Decision Variables Position Matrix

    PositionMin = problem.PositionRange(1); % Lower Bound of Variables position 
    PositionMax = problem.PositionRange(2); % Upper Bound of Variables position 

    %% PSO Parameters

    MaxIt=params.MaxIt;      % Maximum Number of Iterations

    nPop=params.nPop;        % Population Size (Swarm Size)

    % PSO Parameters
    w = .9;
    wdamp = .95;
    alpha = .85; % Personal Learning Coefficient
    beta = .85; % Global Learning Coefficient
    
    showPlot = params.showPlot;
    showIters = params.showIters;

    %% Initialization

    empty_particle.citySequence = [];
    empty_particle.Cost = [];
    empty_particle.Velocity = [];
    empty_particle.Best.citySequence = [];
    empty_particle.Best.Cost = [];

    particle = repmat(empty_particle, nPop, 1);

    GlobalBest.Cost = inf;
    
    % initialize city positions
    cityPositions = unifrnd(PositionMin, PositionMax, PositionSize);
    
    % initialize city positions (for test porpuse with 15 cities and PosiotionRange of 0 100)
%     cityPositions = [    
% 98 75
% 57 6
% 38 27
% 20 72
% 68 27
% 96 91
% 44 72
% 7  71
% 2  40
% 80 17
% 27 41
% 53 78
% 61 20
% 21 41
% 8  91
% 19 96
% 74 50
% 41 49
% 63 72
% 34 63
% 18 35
% 38 76
% 46 43
% 33 41
% 96 58
% 25 18
% 16 91
% 75 24
% 50 13
% 38 40
% 98 100
% 100 75
% 59 94
% 87 3
% 70 78
% 66 45
% 36 23
% 70 78
% 66 45
% 36 23
% 70 46
% 57 90
% 68 4
% 96 24
% 50 90 
% 73 28
% 28 20
% 30 10
% 71 33
% 74 68
% 85 12
%    ];

    for i = 1:nPop
  
        % Initialize city sequence
        particle(i).citySequence = randperm(citiesNumber);
        
        % Initialize Velocity
        particle(i).Velocity = randi(citiesNumber, [2, ceil(citiesNumber/2)]);

        % Evaluation
        particle(i).Cost = CostFunction(particle(i).citySequence, cityPositions);
        
        % Update Personal Best
        particle(i).Best.citySequence = particle(i).citySequence;
        particle(i).Best.Cost = particle(i).Cost;
        
        % Update Global Best
        if particle(i).Best.Cost < GlobalBest.Cost

            GlobalBest = particle(i).Best;

        end

    end

    out.BestCost = zeros(MaxIt,1);

    %% PSO Main Loop
    
    for it = 1:MaxIt

        for i = 1:nPop

            % particle(i).Velocity
            PbestMinusCitySequence = subtract(particle(i).Best.citySequence, particle(i).citySequence);
            GbestMinusCitySequence = subtract(GlobalBest.citySequence, particle(i).citySequence);
            
            temp = [];
            if ~isempty(particle(i).Velocity)
                for k=1:length(particle(i).Velocity(1,:))
                    if rand <= w
                        temp = [temp, particle(i).Velocity(:, k)];
                    end
                end
            end
            if ~isempty(PbestMinusCitySequence)
                for k=1:length(PbestMinusCitySequence(1,:))
                    if rand <= alpha
                        temp = [temp, PbestMinusCitySequence(:, k)];
                    end
                end
            end
            if ~isempty(GbestMinusCitySequence)
                for k=1:length(GbestMinusCitySequence(1,:))
                    if rand <= beta
                        temp = [temp, GbestMinusCitySequence(:, k)];
                    end
                end
            end
            particle(i).Velocity = temp;
            
            % Update Position
            if ~isempty(particle(i).Velocity)
                for k=1:length(particle(i).Velocity(1,:))
                    particle(i).citySequence = swap(particle(i).citySequence, particle(i).Velocity(:, k));
                end
            end

            %% obey constarint

            % Evaluation
            particle(i).Cost = CostFunction(particle(i).citySequence, cityPositions);

            % Update Personal Best
            if particle(i).Cost < particle(i).Best.Cost

                particle(i).Best.citySequence = particle(i).citySequence;
                particle(i).Best.Cost = particle(i).Cost;

                % Update Global Best
                if particle(i).Best.Cost < GlobalBest.Cost

                    GlobalBest = particle(i).Best;

                end

            end
            
        end

        out.BestCost(it) = GlobalBest.Cost;
        
        if showIters
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(GlobalBest.Cost)]);
        end
        
        % setting sequence of best city position so far for ploting on
        % cartesian coordination
        if showPlot
            CurrentCityPositionSeq = [];
            for i=1:length(GlobalBest.citySequence)
                CurrentCityPositionSeq = [CurrentCityPositionSeq; cityPositions(GlobalBest.citySequence(i), :)];
            end
            CurrentCityPositionSeq = [CurrentCityPositionSeq; cityPositions(GlobalBest.citySequence(1), :)];

            fontSize = 12;
            x = CurrentCityPositionSeq(:, 1);
            y = CurrentCityPositionSeq(:, 2);
            plot(x, y, 'bo-', 'LineWidth', 1, 'MarkerSize', 4);
            pause(0.1)
            grid on;
            title(['iteration' num2str(it)], 'FontSize', fontSize);
            xlabel('X', 'FontSize', fontSize);
            ylabel('Y', 'FontSize', fontSize);
            % Now plot index numbers along side the markers.
            hold off;
        end

        w = w * wdamp;
        
    end

    out.BestSol = GlobalBest;
    
end








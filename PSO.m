function res_y= my_PSO(path)
    disp("调用pso");
    %% 参数初始化
    %粒子群算法中的两个参数
    c1 = 1.5;
    c2 = 1.5;
    D=10;%粒子维数
    maxgen=4000;   % 进化次数  
    sizepop=100;   %种群规模
    Vmax=1;
    Vmin=-1;
    popmax=5;
    popmin=-5;

    disp("pso" + path);
    %path = 'E:\matlab2023obj\TSP_problem\qa194tsp.txt';
    distanceMatrix = readData(path);
    D=size(distanceMatrix,2);%粒子维数
    % 预分配数组
    pop = zeros(sizepop, D);
    V = zeros(sizepop, D);
    fitness = zeros(sizepop, 1);
    Poolx = zeros(sizepop, D);
    PoolVx = zeros(sizepop, D);
    childx1 = zeros(sizepop, D);
    childv1 = zeros(sizepop, D);
    mutationchild = zeros(sizepop, D);
    yy3 = zeros(maxgen, 1);
    gbest = zeros(sizepop, D);
    fitnessgbest = zeros(sizepop, 1);
    zbest = zeros(1, D);
    fitnesszbest = Inf;
    %% 产生初始粒子和速度
    for i=1:sizepop
        %随机产生一个种群
        pop(i,:)=rands(1,D);    %初始种群
        V(i,:)=rands(1,D);  %初始化速度
        %计算适应度
        fitness(i)= fun(pop(i,:),distanceMatrix);   %粒子的适应值
    end
    
    %% 个体极值和群体极值
    [bestfitness bestindex]=min(fitness);
    zbest=pop(bestindex,:);   %全局最佳
    gbest=pop;    %个体最佳
    fitnessgbest=fitness;   %个体最佳适应度值
    fitnesszbest=bestfitness;   %全局最佳适应度值
    
    %% 迭代寻优
    for i=1:maxgen
        
        for j=1:sizepop
            
            %速度更新
            V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
            V(j,find(V(j,:)>Vmax))=Vmax;
            V(j,find(V(j,:)<Vmin))=Vmin;
            
            %种群更新
            pop(j,:)=pop(j,:)+V(j,:);
            pop(j,find(pop(j,:)>popmax))=popmax;
            pop(j,find(pop(j,:)<popmin))=popmin;
            
            %适应度值
            fitness(j)=fun(pop(j,:),distanceMatrix); 
       
        end
        
        for j=1:sizepop
            
            %个体最优更新
            if fitness(j) < fitnessgbest(j)
                gbest(j,:) = pop(j,:);
                fitnessgbest(j) = fitness(j);
            end
            
            %群体最优更新
            if fitness(j) < fitnesszbest
                zbest = pop(j,:);
                fitnesszbest = fitness(j);
            end
        end 
        yy1(i)=fitnesszbest;   
        
    end
    res_y = yy1;
end

clc
clear
%杂交概率：Pc
%杂交池大小比例：Sp
%最大迭代次数：M
%问题的维数：D
%目标函数取最小值时的自变量值：xm
%目标函数的最小值：fv
%% 参数初始化
%粒子群算法中的两个参数
c1 = 1.5;%学习因子
c2 = 1.5;%学习因子
wmax=0.9;%惯性因子最大值
wmin=0.4;%惯性因子最小值

pc=0.7;%杂交概率
maxgen=4000;   % 迭代次数  
sizepop=100;   %种群规模
pm=0.05;%变异概率
Vmax=1;
Vmin=-1;
popmax=4;
popmin=-4;
%path = 'E:\matlab2023obj\TSP_problem\xpr2308tsp.txt';

% 获取所有TSP文件
fileFolder = 'E:\matlab2023obj\TSP_problem';
files = dir(fullfile(fileFolder, '*.txt'));
resultsFolder = 'E:\matlab2023obj\TSP_result';

% 遍历所有文件
for file = files'
    path = fullfile(fileFolder, file.name);
    disp(path);
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
        %pop(i,:)=randdata1(1,:);    %初始化粒子位置
        %V(i,:)=randdata2(1,:);  %初始化粒子速度
        pop(i,:)=rands(1,D);    %初始种群
        %pop(i,:)=[53, 61, 64, 62, 79, 78, 83, 85, 71, 72, 70, 65, 69, 77, 76, 74, 67, 73, 46, 30, 36, 39, 10, 23, 43, 55, 48, 47, 54, 68, 82, 87, 81, 80, 86, 88, 92, 101, 98, 118, 110, 103, 116, 119, 109, 128, 121, 94, 93, 91, 106, 115, 114, 126, 125, 130, 124, 120, 99, 95, 96, 102, 104, 113, 122, 129, 123, 107, 112, 105, 100, 111, 97, 117, 108, 127, 89, 90, 84, 75, 66, 37, 34, 33, 51, 58, 57, 59, 60, 22, 38, 50, 49, 32, 8, 5, 0, 19, 6, 1, 2, 3, 9, 7, 26, 44, 12, 4, 17, 28, 21, 40, 42, 41, 35, 56, 63, 45, 27, 25, 24, 13, 18, 16, 29, 20, 31, 11, 14, 15, 52];
    
        V(i,:)=rands(1,D);  %初始化速度
        fitness(i)=fun(pop(i,:),distanceMatrix);   %计算每个粒子的适应度值
    end
    
    
    %% 个体极值和群体极值
    [bestfitness bestindex]=min(fitness);
    zbest=pop(bestindex,:);   %全局最佳
    gbest=pop;    %个体最佳
    fitnessgbest=fitness;   %个体最佳适应度值
    fitnesszbest=bestfitness;   %全局最佳适应度值
    
    %% 迭代寻优
    for k=1:maxgen
        for j=1:sizepop
            %速度更新
            V(j,:) =V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
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
        [sortbest sortindexbest]=sort(fitnessgbest);%按照适应度大小进行排序
        numPool=round(pc*sizepop);            %杂交池的大小,round为取整
        for i=1:numPool
            Poolx(i,:)=pop(sortindexbest(i),:);
            PoolVx(i,:)=V(sortindexbest(i),:);
        end
        for i=1:numPool  %选择要进行杂交的粒子
            seed1=floor(rand()*numPool)+1;
            seed2=floor(rand()*numPool)+1;
            while seed1==seed2
            seed1=floor(rand()*numPool)+1;
            seed2=floor(rand()*numPool)+1;
            end
            pb=rand;
            %子代的位置计算
            childx1(i,:)=pb*Poolx(seed1,:)+(1-pb)*Poolx(seed2,:);
            %子代的速度计算
            childv1(i,:)=(PoolVx(seed1,:)+PoolVx(seed2,:))*norm(PoolVx(seed1,:))./norm(PoolVx(seed1,:)+PoolVx(seed2,:));
            if fun(pop(i,:),distanceMatrix)>fun(childx1(i,:),distanceMatrix)
               pop(i,:)=childx1(i,:); %子代的位置替换父代位置
                V(i,:)=childv1(i,:); %子代的速度替换父代速度
            end
            
        end
        
    %%进行高斯变异
       mutationpool=round(pm*sizepop);
       for i=1:mutationpool  %选择要进行变异的粒子
           seed3=floor(rand()*mutationpool)+1;
           mutationchild(i,:)=pop(seed3,:)*(1+ randn);
           if fun(pop(i,:),distanceMatrix)>fun(mutationchild(i,:),distanceMatrix)
                 pop(i,:)=mutationchild(i,:); %子代的位置替换父代位置
           end
       end
           
          
        %计算杂交变异后的粒子适应度值以及进行更新
        for q=1:sizepop
            %适应度值
            fitness(q)=fun(pop(q,:),distanceMatrix); 
            %个体最优更新
            if fitness(q) < fitnessgbest(q)
                gbest(q,:) = pop(q,:);
                fitnessgbest(q) = fitness(q);
            end
            %群体最优更新
            if fitness(q) < fitnesszbest
                zbest = pop(q,:);
                fitnesszbest = fitness(q);
            end
        end 
        yy3(k)=fitnesszbest;
    end
    %% 结果分析
     %  离散化
    % 初始化离散化种群数组
    discretePop = zeros(1, D);
    solution = zbest(1, :);
    [~, sortIndex] = sort(solution);
    rank = zeros(1, D);
    rank(sortIndex) = 1:D;
    discretePop(1, :) = rank;
    zbest = discretePop;
    disp("即将调用pso");
    yy1 = my_PSO(path);


    plot(yy1,'k','LineWidth',1)
    hold on
    plot(yy3,'r','LineWidth',1)
    xlabel('迭代次数','fontsize',15);ylabel('适应度值','fontsize',15);
    legend('粒子群算法','基于遗传思想的粒子群算法');
    saveas(gcf, fullfile(resultsFolder, [file.name, '_plot.fig']));
    saveas(gcf, fullfile(resultsFolder, [file.name, '_plot.png']));
    % 保存适应度最小值
    minbest = min(yy1);
    meanbest = mean(yy1);
    stdbest = std(yy1);
    save(fullfile(resultsFolder, [file.name, '_PSOresults.mat']), 'minbest', 'meanbest', 'stdbest');

    % 保存适应度最小值
    minbest = min(yy3);
    meanbest = mean(yy3);
    stdbest = std(yy3);
    save(fullfile(resultsFolder, [file.name, '_GAPSOresults.mat']), 'minbest', 'meanbest', 'stdbest');
    disp("已保存");
    close all; % 关闭图形窗口
end

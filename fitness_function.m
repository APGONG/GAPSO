function dist = fun(PopDec,distanceMatrix)
    n = size(PopDec,1);
    d = size(PopDec,2);
 
    %  离散化
    % 初始化离散化种群数组
    discretePop = zeros(n, d);
    % 遍历每一个解
    for i = 1:n
        solution = PopDec(i, :);
        [~, sortIndex] = sort(solution);
        rank = zeros(1, d);
        rank(sortIndex) = 1:d;
        discretePop(i, :) = rank;
    end
    PopDec = discretePop;
    n = length(PopDec);
    dist = 0;
    for i = 2:n
        
        dist = dist + distanceMatrix(PopDec(i-1), PopDec(i));
    end
    dist = dist + distanceMatrix(PopDec(n), PopDec(1)); % 回到起点的距离
end    

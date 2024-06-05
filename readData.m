function distanceMatrix = readData(file_path)
    % 读取文件中的数据
    data = load(file_path);
    
    % 分离坐标数据
    coordinates = data(:, 2:3);
    
    % 获取点的数量
    num_points = size(coordinates, 1);
    
    % 初始化距离矩阵
    distanceMatrix = zeros(num_points, num_points);
    
    % 计算每对点之间的距离
    for i = 1:num_points
        for j = 1:num_points
            distanceMatrix(i, j) = sqrt((coordinates(i, 1) - coordinates(j, 1))^2 + (coordinates(i, 2) - coordinates(j, 2))^2);
        end
    end
    
end

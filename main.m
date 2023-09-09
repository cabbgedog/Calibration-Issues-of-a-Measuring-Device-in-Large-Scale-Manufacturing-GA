clc;                

tic;
data = dlmread('dataform_train2023.csv');
Trow = 1:2:(size(data,1) - 1);       %温度所在行数
Vrow = 2:2:(size(data,1));           %电压所在行数
Tmark = data(Trow,:);                %温度
Vmark = data(Vrow,:);                %电压
realnum = length(Trow);              %测试数据数 
Point = 6;       
Group = 50;        %种群个体数目 
G = 50;            %代际循环次数
numm = 90;          %样本点总数目
Pc = 0.9;           %交叉概率
Pm = 0.01;          %变异概率
Generation = init(Group, numm, Point);   %产生初始化种群 
FV = zeros(1, Group);       %每次循环中个体的适应度
bests = zeros(1, G);                 %每次循环的最好结果
aves= zeros(1, G);                 %每次循环的平均结果
nextGeneration = zeros(Group, Point);       %下一代

for k = 1:G
    for i = 1:Group
       FV(i) = costf(Generation(i,:), numm, Tmark, Vmark, Point, realnum); 
    end
    maxF = max(FV);          %成本最大值
    minF = min(FV);          %成本最小值
    aveF = mean(mink(FV,8));
    pos = find(FV == minF);
    BestGeneration = Generation(pos(1, 1), :);      %历代中最优个体
    FV = (maxF - FV)/(maxF - minF);
    sF = sum(FV);
    fv = FV./sF;                 
    fv = cumsum(fv);                    
    RandIndex = sort(rand(1, Group));            
    fi = 1;
    ni = 1;
   while ni <= Group                                      
        if (RandIndex(ni)) < fv(fi)
            nextGeneration(ni,:) = Generation(fi,:);
            ni = ni + 1;
        else
            fi = fi + 1;
        end
       
   end
%进行基因交叉
  for i = 1:2:Group
    if rand < Pc
        q = randi([0, 1], 1, Point);
        for j = 1:Point
            if q(j) == 1
                temp = nextGeneration(i + 1, j);
                nextGeneration(i + 1, j) = nextGeneration(i, j);
                nextGeneration(i, j) = temp;
                if check(nextGeneration(i,:)) > 0 || check(nextGeneration(i + 1,:)) > 0
                    nextGeneration(i, j) = nextGeneration(i + 1, j);
                    nextGeneration(i + 1, j) = temp;
                end
            end
        end
        % 对基因序列进行排序
        nextGeneration(i,:) = sort(nextGeneration(i,:));
        nextGeneration(i + 1,:) = sort(nextGeneration(i + 1,:));
    end
end

%交叉的优化的改进如下：

%1. 将随机数生成和判断操作合并，减少代码及操作次数。
%3. 在基因交叉时，仅对修改过的基因进行排序，避免对整个基因序列进行排序，减少运算量。

%进行基因变异
   for i = 1:Group
    for j = 1:Point
        if rand < Pm
            bool1 = 1;
            while bool1 > 0
                nextGeneration(i, j) = randi([1, numm]);
                bool1 = check(nextGeneration(i,:));
            end
        end
    end
    nextGeneration(i,:) = sort(nextGeneration(i,:));   
   end
   Generation = nextGeneration;         
   Generation(1,:) = BestGeneration;    %确保上代最优进入下一代
   bests(k) = minF;
   aves(k)= aveF;
   fprintf('进度%7.1f %%  ',k/G*100); 
   fprintf('耗时%7.3fs.\n',toc);
end

fprintf('最低成本: %d\n', bests(k));
fprintf('温度测量点为：');
disp(BestGeneration);
plot(bests,'r');
ylim([0 3000]);
hold on
plot(aves,'b');
grid on
xlabel('迭代次数');
ylabel('最优成本/平均成本');
title('遗传算法的趋势图');


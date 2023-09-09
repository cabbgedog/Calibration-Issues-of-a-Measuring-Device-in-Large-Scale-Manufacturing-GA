%计算群体中每个个体的适应度
function result = costf(g, numm, Tmark, Vmark, Point, realnum)
result = 0;
selected = g;              %SelectP即为个体选中的样本点的坐标数组
cost = zeros(1, numm);      %记录插值结果与真实结果的区别
for i = 1:realnum
    T_i = Tmark(i, selected);      %数据集中第i组选择的温度样本点
    V_i = Vmark(i, selected);      %数据集中第i组选择的电压样本点
    T_i_all = Tmark(i,:);         %数据集中第i组全部的温度值
    V_i_all = Vmark(i,:);         %数据集中第i组全部的电压值
    T_current = interp1(V_i, T_i, V_i_all, 'spline');
    cost = abs(T_i_all - T_current);
   for j = 1:numm     
    switch true
        case cost(j) > 2
            result = result + 100000;
        case cost(j) > 1.5
            result = result + 30;
        case cost(j) > 1
            result = result + 10;
        case cost(j) > 0.5
            result = result + 1;
    end
   end
end
result = result / realnum;
result = result + Point*80;

% 优化后使用了switch语句，将多个if-elseif语句合并，使代码更加简洁易读。在条件语句中使用true值，让每个case表达式都能被求值。同时，也避免了在每个case表达式中写入cost(j) > 2等条件，减少了冗余代码。   
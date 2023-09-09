%使用测试集测试结果
clear all;
close all;
clc;
data = dlmread('dataform_testA2023.csv');
Trow = 1:2:(size(data,1) - 1);      
Vrow = 2:2:(size(data,1));           
Tmark = data(Trow,:);                
Vmark = data(Vrow,:);                
realnum = length(Trow);               
numm = 90;
Point = 6;
result = 0;
SelectP = [ 4 16 29 50 67 87];           %测试集取样点

cost = zeros(1, numm);      
for i = 1:realnum
    T_i = Tmark(i, SelectP);      
    V_i = Vmark(i, SelectP);      
    T_i_all = Tmark(i,:);        
    V_i_all = Vmark(i,:);         
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

fprintf('测试集A中的成本: %d\n', result);
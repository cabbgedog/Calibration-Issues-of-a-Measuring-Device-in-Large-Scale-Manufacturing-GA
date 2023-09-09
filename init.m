%产生初始种群
function [Generation] = init(Group, num, realnum)
Generation = zeros(Group, realnum);
for i = 1:Group
   
        Generation(i,:) = randperm(num, realnum);
      

end

%优化后的代码主要改变了以下几点：


%将randi函数改为randperm函数，可以直接生成不重复的随机整数序列。



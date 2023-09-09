%判断数组中是否有重复元素，若无重复元素则返回0
function [result] = check(ar)
if numel(unique(ar)) == numel(ar)
    result = 0;
else
    result = 1;
end
%优化原因：使用numel代替length函数，可以提高程序的运行效率。同时，unique函数的计算量比较大，如果将unique函数的结果与ar的长度进行比较，需要先将ar进行一次排序，这也会造成一些时间上的延迟。所以，使用numel(unique(ar)) == numel(ar)进行比较，可以避免这个问题。
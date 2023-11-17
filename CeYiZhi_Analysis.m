function CeYiZhi_Analysis(dataArri,nTrials)

% TO DO：把一致和不一致时的正确率也加进去，把全部正确选择的meanRT和stdRT加进去改后记得把编数据的程序也改一下

%% 定义处理后的结构数据 1是一致，0是不一致
dataCalc = struct('num',[],'accuRent',[],...
    'meanRT_1',[],'stdRT_1',[],'meanRT_0',[],'stdRT_0',[],...
    'nTrials',[],'gender',[],'grade',[],'age',[],'hand',[]);
dataRight = struct('Trial', [], 'Congruency', [], 'RT', []);

%% 获取被试信息
dataCalc.gender = input('请输入您的性别(女性请输入0/男性请输入1):');
dataCalc.grade = input('请输入您的本科年级(23/22/21/...):');
dataCalc.age = input('请输入您的当前年龄(18/19/20/...):');
dataCalc.hand = input('请输入您的惯用手(左手请输入0/右手请输入1):');
dataCalc.num = string(datetime('now','Format','yyMMddHHmmss'));
dataCalc.nTrials = nTrials;

%% 处理并保存到变量
nRight = 0;
for i = 1:nTrials
    if dataArri(i).Accuracy == 1
        nRight = nRight + 1;% 记录正确次数
        dataRight(nRight).Trial = nRight;
        dataRight(nRight).Congruency = dataArri(i).Congruency;%将正确试次的数据保存到新变量
        dataRight(nRight).RT = dataArri(i).RT;
    end
end

%% 计算所有正确选择的反应时和标准差
dataCalc.accuRent = nRight / nTrials;%计算总正确率




%% 计算一致和不一致两种情况的反应时的均值和标准差
% 遍历 dataRight 结构体
RT_1 = zeros(1, length(dataRight));
RT_0 = zeros(1, length(dataRight));
for i = 1:length(dataRight)
    if dataRight(i).Congruency == 1
        RT_1(i) = dataRight(i).RT;
    elseif dataRight(i).Congruency == 0
        RT_0(i) = dataRight(i).RT;
    end
end
RT_1 = nonzeros(RT_1);
RT_0 = nonzeros(RT_0);
% 计算均值和标准差
dataCalc.meanRT_1 = mean(RT_1);
dataCalc.stdRT_1 = std(RT_1);
dataCalc.meanRT_0 = mean(RT_0);
dataCalc.stdRT_0 = std(RT_0);

%% 添加dataCalc变量的数据到文件中
% 将结构体转换为表格
t = struct2table(dataCalc);

% 定义文件名
filename = 'dataCalc.csv';

% 检查文件是否存在
if exist(filename, 'file') == 2
    % 读取文件内容
    oldData = readtable(filename);
    
    % 合并旧数据和新数据
    newData = vertcat(oldData, t);
    
    % 写入新数据
    writetable(newData, filename);
else
    % 写入新数据
    writetable(t, filename);
end


% 初始化PsychtoolboxJJJJJFJFFJJFFJJFJJFJFFFJJJJFFFJJFFJFFFJFFFFJFJFFFFJJFFJFFJFFFJJFJFFFJJFJJJ
clear;
clc;
AssertOpenGL; % 检查 Psychtoolbox 是否正常运行
Screen('Preference', 'VisualDebugLevel', 0); % 跳过青蛙画面（0）
Screen('Preference', 'SkipSyncTests', 1); % 跳过同步测试（1）
screenNumber = max(Screen('Screens')); % 获取屏幕编号
[window, windowRect] = Screen('OpenWindow', screenNumber); % 打开一个窗口
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA'); % 设置颜色混合模式
[xCenter, yCenter] = RectCenter(windowRect); % 获取屏幕中心坐标
Screen('TextFont', window, 'SimHei'); % 设置字体
KbName('UnifyKeyNames'); % 统一键盘名称
escapeKey = KbName('ESCAPE'); % 定义退出键
leftKey = KbName('f'); % 定义向左键
rightKey = KbName('j'); % 定义向右键
HideCursor;% 隐藏鼠标

% 定义数据储存变量
dataArri = struct('Trial', [], 'Congruency', [], 'Target', [], 'Response', [], 'Accuracy', [], 'RT', []);

% 定义指导语和结束语
instruction = ['欢迎参加本次实验\n\n',...
    '在接下来的实验中，屏幕中央会呈现五个箭头，如 < < < < < 或 < < > < <\n\n',...
    '您需要根据中间的那一个箭头的指向，朝左则尽快按 F 键，朝右则尽快按 J 键\n\n',...
    '例如，对于上面的第一个例子，中间的那个箭头 < 朝左，您需要尽快按 F 键\n\n',...
    '又如，对于上面的第二个例子，中间的那个箭头 > 朝右，您需要尽快按 J 键\n\n',...
    '如需中途退出，请按 Esc 键\n\n',...
    '\n\n如果您已经清楚实验规则，请按任意键开始试验'];
suggestion = ['请开启大写锁定以避免输入法干扰\n\n',...
    '如已开启，请等待3秒钟，实验将自动开始'];
ending = ['实验结束，感谢您的参与\n\n',...
    '请按任意键退出'];

% 定义实验参数
nTrials = 72; % 实验次数:要求为72
arrowColor = [0 0 0]; % 箭头颜色（RGB值）
arrowDuration = 1.5; % 箭头呈现时间（秒）
feedbackDuration = 0.4; % 反馈呈现时间（秒）
iti = 1; % inter-trial interval，试次间隔时间（秒）
leftArrow = '<'; % 向左箭头符号
rightArrow = '>'; % 向右箭头符号
correctSymbol = '√'; % 正确反馈符号
wrongSymbol = '×'; % 错误反馈符号
feedbackColor = [0 255 0; 255 0 0]; % 反馈颜色，第一行为正确颜色，第二行为错误颜色
ESC = 0;% 用这个变量来记录有没有中途退出，1就是退出了

% 生成实验序列
targetDirection = Shuffle(repmat([0 1], 1, nTrials/2)); % 目标箭头朝向，0为左，1为右，随机打乱顺序
flankerCongruency = Shuffle(repmat([0 1], 1, nTrials/2)); % 其他箭头是否与目标箭头一致，0为不一致，1为一致，随机打乱顺序

% 创建数据文件(原始数据保存到文件模块1/3)
%dataFile = fopen('lateral_inhibition_data.txt', 'w'); % 打开一个文本文件，用于保存数据
%fprintf(dataFile, 'Trial\tCongruency\tTarget\tResponse\tAccuracy\tRT\n'); % 写入表头

% 显示指导语
Screen('TextSize', window, 40); % 设置字号
DrawFormattedText(window,double(suggestion),'center','center',[0 0 0]);
Screen('Flip', window);
WaitSecs(3); % 等待x秒钟
DrawFormattedText(window,double(instruction),'center','center',[0 0 0]);
Screen('Flip', window); % 更新屏幕
KbStrokeWait; % 等待按键继续

% 开始实验
Screen('TextSize', window, 100); % 设置字号
for i = 1:nTrials % 对每个试次进行循环
    
    % 根据实验序列生成箭头字符串
    if targetDirection(i) == 0 % 如果目标箭头朝左
        targetArrow = leftArrow; % 设置目标箭头符号为左箭头
    else % 如果目标箭头朝右
        targetArrow = rightArrow; % 设置目标箭头符号为右箭头
    end
    
    if flankerCongruency(i) == 0 % 如果其他箭头与目标箭头不一致
        if targetDirection(i) == 0 % 如果目标箭头朝左
            flankerArrow = rightArrow; % 设置其他箭头符号为右箭头
        else % 如果目标箭头朝右
            flankerArrow = leftArrow; % 设置其他箭头符号为左箭头
        end
    else % 如果其他箭头与目标箭头一致
        flankerArrow = targetArrow; % 设置其他箭头符号与目标箭头相同
    end
    
    arrowString = [flankerArrow ' ' flankerArrow ' ' targetArrow ' ' flankerArrow ' ' flankerArrow]; % 生成箭头字符串，例如"> > < > >"
    
    % 在屏幕上呈现箭头
    DrawFormattedText(window, arrowString, 'center', 'center', arrowColor); % 在屏幕中央绘制箭头字符串，可以通过调整最后一个参数来设置箭头间隔
    Screen('Flip', window); % 更新屏幕
    arrowOnset = GetSecs; % 记录箭头出现的时间
    
    % 等待被试按键或箭头呈现时间结束
    keyCode = zeros(1, 256); % 创建一个存储按键信息的变量
    while (GetSecs - arrowOnset) < arrowDuration && ~keyCode(escapeKey) && ~keyCode(leftKey) && ~keyCode(rightKey) % 当时间没有超过箭头呈现时间且没有按退出键或左右键时，保持循环
        [keyIsDown, ~, keyCode] = KbCheck; % 检测是否有按键按下
    end
    
    % 判断被试的反应是否正确以及反应时
    if keyCode(escapeKey) % 如果按了退出键
        ESC = 1;
        break; % 跳出循环，结束实验
    elseif keyCode(leftKey) % 如果按了向左键
        responseDirection = 0; % 记录被试的反应朝向为左
        rt = GetSecs - arrowOnset; % 记录反应时
        if targetDirection(i) == responseDirection % 如果被试的反应朝向与目标箭头朝向一致
            accuracy = 1; % 记录反应正确
            feedbackSymbol = correctSymbol; % 设置反馈符号为正确符号
            feedbackIndex = 1; % 设置反馈颜色索引为1
        else % 如果被试的反应朝向与目标箭头朝向不一致
            accuracy = 0; % 记录反应错误
            feedbackSymbol = wrongSymbol; % 设置反馈符号为错误符号
            feedbackIndex = 2; % 设置反馈颜色索引为2
        end
    elseif keyCode(rightKey) % 如果按了向右键
        responseDirection = 1; % 记录被试的反应朝向为右
        rt = GetSecs - arrowOnset; % 记录反应时
        if targetDirection(i) == responseDirection % 如果被试的反应朝向与目标箭头朝向一致
            accuracy = 1; % 记录反应正确
            feedbackSymbol = correctSymbol; % 设置反馈符号为正确符号
            feedbackIndex = 1; % 设置反馈颜色索引为1
        else % 如果被试的反应朝向与目标箭头朝向不一致
            accuracy = 0; % 记录反应错误
            feedbackSymbol = wrongSymbol; % 设置反馈符号为错误符号
            feedbackIndex = 2; % 设置反馈颜色索引为2
        end        
    else % 如果没有按任何键
        responseDirection = NaN; % 记录被试的反应朝向为空值
        rt = NaN; % 记录反应时为空值
        accuracy = NaN; % 记录反应正确性为空值
        feedbackSymbol = wrongSymbol; % 设置反馈符号为错误符号
        feedbackIndex = 2; % 设置反馈颜色索引为2       
    end
    
    % 在屏幕上呈现反馈信息
    DrawFormattedText(window, double(feedbackSymbol), 'center', 'center', feedbackColor(feedbackIndex, :)); % 在屏幕中央绘制反馈符号，颜色根据反馈颜色索引确定
    Screen('Flip', window); % 更新屏幕
    arrowOnset = GetSecs; % 记录反馈出现的时间

    % 等待反馈呈现时间结束或被试按退出键
    keyCode = zeros(1, 256); % 重置按键信息变量
    while (GetSecs - arrowOnset) < feedbackDuration && ~keyCode(escapeKey) % 当时间没有超过反馈呈现时间且没有按退出键时，保持循环
        [keyIsDown, ~, keyCode] = KbCheck; % 检测是否有按键按下
    end
    
    if keyCode(escapeKey) % 如果按了退出键
        ESC = 1;
        break; % 跳出循环，结束实验
    end
    
    % 把本次试次的数据写入文件(原始数据保存到文件模块2/3)
    %fprintf(dataFile, '%d\t%d\t%d\t%d\t%d\t%.3f\n', i, flankerCongruency(i), targetDirection(i), responseDirection, accuracy, rt); % 写入试次序号、箭头方向是否一致、目标箭头朝向、被试按键代表的朝向、被试反应是否正确、反应时
    % 把本次试次的数据写入变量
    dataArri(i).Trial = i;
    dataArri(i).Congruency = flankerCongruency(i);
    dataArri(i).Target = targetDirection(i);
    dataArri(i).Response = responseDirection;
    dataArri(i).Accuracy = accuracy;
    dataArri(i).RT = rt;

    % 在屏幕上呈现黑色背景，表示试次间隔
    Screen('Flip', window); % 更新屏幕
    arrowOnset = GetSecs; % 记录间隔出现的时间
    
    % 等待试次间隔时间结束或被试按退出键
    keyCode = zeros(1, 256); % 重置按键信息变量
    while (GetSecs - arrowOnset) < iti && ~keyCode(escapeKey) % 当时间没有超过试次间隔时间且没有按退出键时，保持循环
        [keyIsDown, ~, keyCode] = KbCheck; % 检测是否有按键按下
    end
    
    if keyCode(escapeKey) % 如果按了退出键
        ESC = 1;
        break; % 跳出循环，结束实验
    end
    
end

% 关闭数据文件(原始数据保存到文件模块3/3)
%fclose(dataFile); % 关闭文本文件

% 显示结束语
Screen('TextSize', window, 40); % 设置字号
DrawFormattedText(window, double(ending), 'center', 'center', [0 0 0]); % 在屏幕中央绘制结束语
Screen('Flip', window); % 更新屏幕
KbStrokeWait; % 等待按键继续

% 关闭Psychtoolbox
ShowCursor;% 显示鼠标
sca; % 关闭所有窗口和声音设备，恢复正常屏幕状态

% 调用分析函数(如果没有中途退出)
if ESC == 0
    CeYiZhi_Analysis(dataArri,nTrials);
end

clear;
clc;

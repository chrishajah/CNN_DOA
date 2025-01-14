clear;
% 数据集生成
c = physconst('LightSpeed');     % 光速 m/s
f0 = 10e9;                       % 载波频率 Hz
fg = 50e9;                       % 系统全局采样率
BW = 1e8;                        % 信号带宽
scan_angle = -60:0.1:60;         % 扫描角度，单位为°
lambda = c / f0;                 % 载波波长 m
d = lambda / 2;                  % 阵元间隔 m
shot_len = 128;                  % 快拍数
rec_len = 32;                    % 阵元数

% 数据集初始化
num_samples = 1000; % 数据集样本数量
R_real = zeros(rec_len, rec_len, num_samples);   % 自相关函数实部
R_imag = zeros(rec_len, rec_len, num_samples);   % 自相关函数虚部
R_phase = zeros(rec_len, rec_len, num_samples);  % 自相关函数相位
labels = zeros(1201, num_samples);               % DOA 标签（多标签）
for i = 1:num_samples
    % 随机生成信号参数
    num_sources = randi([1,1]);  % 目标数量
    src_angle = scan_angle(randi(length(scan_angle), [1, num_sources])) % 随机来向角度，直接从scan_angle中选择
    snr = randi([10, 20]);  % 随机信噪比
    is_coherent = false;  % 随机信源是否相干
    
    % 调用回波生成函数生成自相关矩阵
    [x_sig, sigma, R_sig] = echo_generate(rec_len, d, lambda, src_angle, shot_len, f0, BW, fg, snr, is_coherent);
    
    % 将自相关矩阵分解为实部、虚部和相位
    R_real(:,:,i) = real(R_sig);
    R_imag(:,:,i) = imag(R_sig);
    R_phase(:,:,i) = angle(R_sig);
    
    % 生成对应的标签，表示来向角度
    label = zeros(1, 1201);  % 初始化标签
    for j = 1:num_sources
        % 找到与src_angle最接近的scan_angle下标
        [~, angle_index] = min(abs(scan_angle - src_angle(j)));
        
        % 将对应的标签位置置为1
        label(angle_index) = 1;
    end
    % 将该样本的标签保存到 labels 矩阵中
    labels(:, i) = label';  % 每个样本生成一个1201维的标签向量
end
% 保存数据集
save('DOA_dataset.mat', 'R_real', 'R_imag', 'R_phase', 'labels');



% 假设你已经加载了训练好的网络模型
% net = trained_model;

% 加载测试数据
% 如果测试数据存在于.mat文件中，可以使用load命令加载测试数据
% 假设你已经有了test_inputs（[32, 32, 3, 1]）和实际的标签（test_labels）
clear;clc;
load('DOA_dataset.mat', 'R_real', 'R_imag', 'R_phase', 'labels');  % 假设test_inputs是你已经准备好的输入
load("doa_model.mat");
% 构造测试输入
test_inputs = zeros(size(R_real, 1), size(R_real, 2), 3, 1);  % 输入的大小应该是 [32, 32, 3, 1]
test_inputs(:, :, 1, 1) = real(R_real(:, :, 1));  % 使用第一个样本的实部
test_inputs(:, :, 2, 1) = imag(R_imag(:, :, 1));  % 使用第一个样本的虚部
test_inputs(:, :, 3, 1) = angle(R_phase(:, :, 1));  % 使用第一个样本的相位

% 使用训练好的网络进行预测
predicted_scores = predict(net, test_inputs);

% 打印预测的分数，检查是否全部为0
disp('Predicted Scores (first 5 values):');
disp(predicted_scores(1, :, 1));  % 打印第一个测试样本的预测分数

% 将输出的预测分数（概率）转换为标签
predicted_labels = predicted_scores > 0.5;

% 打印预测结果
disp('Predicted Labels:');
disp(predicted_labels);
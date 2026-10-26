% Fig 4.1 - Rate pairs with OFDMA and NOMA (downlink), two users, G1 = G2 = 10
% Project: Performance analysis of NOMA in 5G network
clear all; clc; close all;

%% Parameters
% G1, G2 are linear SNR values: 10 dB = 10 (matches Table 4.1 and Section 4.2.1)
P  = 1;     % total transmit power (normalized)
G1 = 10;    % SNR of user 1 (10 dB)
G2 = 10;    % SNR of user 2 (10 dB)

%% NOMA (power splitting)
count = 1;
for alpha = 0:0.01:1                      % power splitting factor
    P1 = P*alpha;
    P2 = P - P1;
    R1(count) = log2(1 + P1*G1);
    R2(count) = log2(1 + P2*G2/(P1*G2 + 1));   % user 2 after SIC
    count = count + 1;
end
hold on;
plot(R1, R2, 'r');
grid on;

%% OFDMA (bandwidth splitting)
R1 = []; R2 = [];
count = 1;                                % reset counter (NOMA data is already plotted)
for alpha = 0:0.01:1                      % bandwidth splitting factor
    P1 = P/2;
    P2 = P/2;
    R1(count) = alpha*log2(1 + P1*G1/alpha);          % alpha = 0 gives NaN (not plotted)
    R2(count) = (1-alpha)*log2(1 + P2*G2/(1-alpha));  % alpha = 1 gives NaN (not plotted)
    count = count + 1;
end
plot(R1, R2, 'k');

xlabel('Rate of user 1 (bps/Hz)');
ylabel('Rate of user 2 (bps/Hz)');
grid on; box on;
legend('NOMA', 'OFDMA');

% saveas(gcf, '../results/fig4_1_rate_pairs_equal_snr.png');   % optional: export the figure

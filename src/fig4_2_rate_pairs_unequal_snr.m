% Fig 4.2 - Rate pairs with OFDMA and NOMA (downlink), asymmetric channel
% Project: Performance analysis of NOMA in 5G network
clear all; clc; close all;

%% Parameters
% G1, G2 are linear SNR values. User 1 is the stronger user (G1 > G2),
% as in the report text (SNR1 = 20, SNR2 = 10) and as plotted in Fig 4.2.
% (The original appendix had G1 = 10, G2 = 20, i.e. the two values swapped.)
P  = 1;     % total transmit power (normalized)
G1 = 20;    % SNR of user 1 (strong user)
G2 = 10;    % SNR of user 2 (weak user, 10 dB)

%% NOMA (power splitting)
count = 1;
for alpha = 0:0.01:1                      % power splitting factor
    P1 = P*alpha;
    P2 = P - P1;
    R1(count) = log2(1 + P1*G1);
    R2(count) = log2(1 + P2*G2/(P1*G2 + 1));
    count = count + 1;
end
hold on;
plot(R1, R2, 'r');
grid on;

%% OFDMA (bandwidth splitting)
R1 = []; R2 = [];
count = 1;                                % reset counter
for alpha = 0:0.01:1                      % bandwidth splitting factor
    P1 = P/2;
    P2 = P/2;
    R1(count) = alpha*log2(1 + P1*G1/alpha);
    R2(count) = (1-alpha)*log2(1 + P2*G2/(1-alpha));
    count = count + 1;
end
plot(R1, R2, 'k');

xlabel('Rate of user 1 (bps/Hz)');
ylabel('Rate of user 2 (bps/Hz)');
grid on; box on;
legend('NOMA', 'OFDMA');

% saveas(gcf, '../results/fig4_2_rate_pairs_unequal_snr.png');   % optional: export the figure

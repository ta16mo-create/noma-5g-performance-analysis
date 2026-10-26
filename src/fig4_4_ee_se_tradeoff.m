% Fig 4.4 - EE-SE trade-off for NOMA and OFDMA (downlink)
% Project: Performance analysis of NOMA in 5G network
clear all; clc; close all;

B  = 5*10^6;       % bandwidth (Hz)
N0 = 10^-21;       % noise density = 1e-21 W/Hz = -210 dBW/Hz  (Table 4.4)
                   % (NOT -150 dBW/Hz: that value would make SE ~ 0 with these channel gains)
N  = N0*B;         % noise power (W)
G1 = 10^-12;       % channel gain of UE1 (-120 dB)
G2 = 10^-14;       % channel gain of UE2 (-140 dB)
Pcircuit = 100;    % static power consumption at the BS (W)

p_vec = 1:1:100;   % total transmit power (W)

%% NOMA
for k = 1:length(p_vec)
    p  = p_vec(k);
    P1 = p*0.1;                         % less power to UE1 (stronger user)
    P2 = p - P1;
    R1 = B*log2(1 + P1*G1/N);
    R2 = B*log2(1 + P2*G2/(P1*G2 + N));
    R  = R1 + R2;
    SE(k) = R/B;                        % bit/sec/Hz
    EE(k) = R/(Pcircuit + p);           % bit/Joule
end

%% OFDMA
for k = 1:length(p_vec)
    p  = p_vec(k);
    P1 = p/2;
    P2 = p/2;
    R1 = (B/2)*log2(1 + P1*G1/(N0*B/2));
    R2 = (B/2)*log2(1 + P2*G2/(N0*B/2));
    R  = R1 + R2;
    SE_line(k) = R/B;
    EE_line(k) = R/(Pcircuit + p);
end

%% Plot
hold on;
hN = plot(SE,      EE,      'k');
hO = plot(SE_line, EE_line, 'g-');

% Green points: transmit power where each system reaches its maximum EE
[EEmaxN, iN] = max(EE);
[EEmaxO, iO] = max(EE_line);
plot(SE(iN),      EEmaxN, 'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
plot(SE_line(iO), EEmaxO, 'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
fprintf('Max EE: NOMA at P_T = %d W, OFDMA at P_T = %d W\n', p_vec(iN), p_vec(iO));

xlabel('SE (bit/sec/Hz)');
ylabel('EE (bit/joule)');
grid on;
legend([hN hO], 'NOMA', 'OFDMA');

% saveas(gcf, '../results/fig4_4_ee_se_tradeoff.png');   % optional: export the figure

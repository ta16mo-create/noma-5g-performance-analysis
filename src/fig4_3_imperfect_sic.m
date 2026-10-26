% Fig 4.3 - Achievable data rate at user 2 with imperfect SIC
% Project: Performance analysis of NOMA in 5G network
clc; clear variables; close all;

rng(1);                            % fixed seed -> reproducible curves
N = 10^5;                          % number of channel realizations

d1 = 1000; d2 = 500;               % distances of users from the BS (m)
a1 = 0.75; a2 = 0.25;              % power allocation factors
eta = 4;                           % path loss exponent
err = [0 10^-4 10^-3 10^-2];       % SIC error factors (epsilon)

% Rayleigh fading coefficients for both users
h1 = sqrt(d1^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);
h2 = sqrt(d2^-eta)*(randn(1,N) + 1i*randn(1,N))/sqrt(2);

g1 = (abs(h1)).^2;
g2 = (abs(h2)).^2;

Pt = 0:2:40;                       % transmit power (dBm)
pt = (10^-3)*10.^(Pt/10);          % transmit power (linear, W)
BW = 10^6;                         % system bandwidth (Hz)
No = -174 + 10*log10(BW);          % noise power (dBm)
no = (10^-3)*10.^(No/10);          % noise power (linear, W)

p = length(Pt);

for ep = 1:length(err)
    for u = 1:p
        gamma_2d = a2*pt(u)*g2./(err(ep)*a1*pt(u)*g2 + no);
        R2d      = log2(1 + gamma_2d);
        R2d_av(u) = mean(R2d);
    end
    plot(Pt, R2d_av, 'linewidth', 2); hold on;
end

grid on;
xlabel('Transmit power (dBm)');
ylabel('Achievable capacity (bps/Hz)');
title('Achievable data rate at user 2 with imperfect SIC');
legend('\epsilon = 0 (perfect SIC)', '\epsilon = 10^{-4}', ...
       '\epsilon = 10^{-3}', '\epsilon = 10^{-2}');

% saveas(gcf, '../results/fig4_3_imperfect_sic.png');   % optional: export the figure

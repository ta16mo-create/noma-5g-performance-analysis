# Code review notes: report vs. MATLAB scripts

The appendix code was compared with the tables, text and figures of the report.
Every claim below was checked numerically (the same equations were re-computed independently).

## Fixes made in the scripts

| # | File | Problem in the original appendix code | Fix | Justification |
|---|------|---------------------------------------|-----|---------------|
| 1 | `fig4_1`, `fig4_2` | The counter `count` was not reset before the OFDMA loop, so the OFDMA results were appended after the NOMA results. `plot(R1,R2,'k')` then redrew the NOMA curve in black and joined it to the OFDMA curve with a stray line. | `R1 = []; R2 = []; count = 1;` before the OFDMA loop. | The report figures show two clean curves; only the reset version produces them. |
| 2 | `fig4_2` | `G1 = 10; G2 = 20`. | `G1 = 20; G2 = 10`. | The report text says SNR1 = 20 and SNR2 = 10, and the plotted figure has user 1 reaching 4.39 bps/Hz (log2(1+20)) and user 2 reaching 3.46 bps/Hz (log2(1+10)). The original values were swapped. The corrected script reproduces the plotted curves (NOMA end points 4.39 / 3.46, OFDMA end points (0.10, 2.57) and (3.44, 0.09)). |
| 3 | `fig4_3` | No random seed. | Added `rng(1);`. | The curves use random Rayleigh fading, so every run gave slightly different curves. A fixed seed makes the repository reproducible. The curves are practically unchanged (rates at 0/20/40 dBm for epsilon = 0: 0.86 / 5.89 / 12.47 bps/Hz, as in the figure). |
| 4 | `fig4_4` | Comment said `N0 = -150 dBW/Hz` while the value is `1e-21`; unused variables `greenpoint`, `maxEE`; the green points mentioned in Section 4.2.3 were never drawn. | Comment corrected (1e-21 W/Hz = -210 dBW/Hz); unused variables removed; green markers at the maximum-EE points added; the maximum-EE powers are printed. | With `N0 = 1e-21` the script reproduces Fig 4.4 exactly (NOMA peak EE = 4.87e5 bit/J at SE = 11.5; OFDMA peak EE = 3.61e5 bit/J at SE = 8.7). With the commented value `1e-15` (-150 dBW/Hz) SE would be about 0 for the channel gains -120 dB / -140 dB, so -150 dBW/Hz cannot be the value that was used. The code, Table 4.4 and the figure agree; only the text was wrong. |

Fig 4.1 (`G1 = G2 = 10`) was left as is: the code, Table 4.1, the caption and Section 4.2.1 all say 10 dB (= 10 linear).

## Corrections needed in the report (not applied to the .docx)

| Where | Currently | Should be | Why |
|-------|-----------|-----------|-----|
| Table 4.2 | G1 = 10, G2 = 20 | G1 = 20, G2 = 10 | Matches the text (SNR1 = 20, SNR2 = 10) and the plotted figure. |
| Fig 4.1 (image) | Curves reaching 4.39 bps/Hz on both axes (this corresponds to G1 = G2 = 20) | Replace with the plot from `fig4_1_rate_pairs_equal_snr.m` (`results/fig4_1_rate_pairs_equal_snr.png`, curves reaching 3.46 bps/Hz) | Table 4.1, the caption and the text all state 10 dB (G = 10). The image was produced with different values. |
| Section 4.2.1 | "both users experience 1.6 bps/Hz" | "about 1.7 bps/Hz" | For G1 = G2 = 10 the equal-rate point is log2(1+10)/2 = 1.73 bps/Hz for both NOMA and OFDMA. |
| Section 4.2.1 / Table 4.2 labels | "SNR1 = 20 dB" | "SNR1 = 20 (linear)" or "13 dB" | The code uses linear values: 20 linear = 13 dB, not 20 dB (20 dB would be 100 linear). |
| Table 4.3 | `h = sqrt(d^eta)*...` | `h = sqrt(d^-eta)*...` | The code uses `d^-eta` (path loss). Only this version reproduces Fig 4.3. |
| Section 4.2.3 | "N0 = -150 dBW/Hz" | "N0 = 10^-21 W/Hz (-210 dBW/Hz)" | See fix 4 above; also matches Table 4.4. |
| Section 4.2.3 | max EE at "17 W and 18 W" | "18 W (NOMA) and 20 W (OFDMA)" | On the 1 W grid used in the code the maxima are at 18 W and 20 W. The EE curves are very flat near the peak (differences below 0.1 %), so a one-step difference is easy to misread. |

## Note on the images

`results/fig4_3_imperfect_sic.jpg` and `results/fig4_4_ee_se_tradeoff.jpg` are taken from the report.
`results/fig4_1_...png` and `results/fig4_2_...png` were generated from the corrected equations with a Python re-implementation (MATLAB was not available while preparing the repository). To use MATLAB exports instead, run the scripts and uncomment the `saveas(...)` line at the end of each file.

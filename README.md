# hBayesDM_PRL
This is the R code I used to for my MPhil thesis. The script use Hierarchical Bayesian Modelling (hBayesDM; Ahn et al., 2017) to fit data of a Probabilistic Reverse Learning (PRL) Task to different versions of reinforcement learning models. Fit indexs are compared to determine a winning model, which is used to estimate the parameters of each participants. The estimates were used as the regressors of the linear model of EEG signals.

## Models
1. Win-Stay-Loss-Switch Model (prl_wsls_multipleB)
2. Rescorla-Wagner Model (prl_delta_multipleB)
3. Fictitious Update Model (prl_fictitious_multipleB)
4. Reward-Punishment Model (prl_rp_multipleB)
5. Reward-Punishment Fictitious Update Model (prl_fictitious_rp_multipleB)

## Estimates
- Learning rate (shared or differ between reward and non-reward trials depends on models)
- Inverse Temperature
- Indecision point

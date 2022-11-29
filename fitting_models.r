library(hBayesDM)

setwd("working folder")
dataPath = "data_path"

# Fit Model
model0 = prl_wsls_multipleB(data=dataPath, niter=5000, nwarmup=1000, nchain=4, ncore=16, modelRegressor=TRUE, inc_postpred = TRUE)
saveRDS(model0, file = "model0.rds", compress = TRUE)
model1 = prl_delta_multipleB(data=dataPath, niter=5000, nwarmup=1000, nchain=4, ncore=16, modelRegressor=TRUE, inc_postpred = TRUE)
saveRDS(model1, file = "model1.rds", compress = TRUE)
model2 = prl_fictitious_multipleB(data=dataPath, niter=5000, nwarmup=1000, nchain=4, ncore=16, modelRegressor=TRUE, inc_postpred = TRUE)
saveRDS(model2, file = "model2.rds", compress = TRUE)
model3 = prl_rp_multipleB(data=dataPath, niter=5000, nwarmup=1000, nchain=4, ncore=16, modelRegressor=TRUE, inc_postpred = TRUE)
saveRDS(model3, file = "model3.rds", compress = TRUE)
model4 = prl_fictitious_rp_multipleB(data=dataPath, niter=5000, nwarmup=1000, nchain=4, ncore=16, modelRegressor=TRUE, inc_postpred = TRUE)
saveRDS(model4, file = "model4.rds", compress = TRUE)


# Compare Models
model0 <- readRDS(file = "model0.rds")
model1 <- readRDS(file = "model1.rds")
model2 <- readRDS(file = "model2.rds")
model3 <- readRDS(file = "model3.rds")
model4 <- readRDS(file = "model4.rds")

printFit(model0, model1, model2, model3, model4, ic="both")


# Export regressors to matlab
library(R.matlab)
ev_c_all = model0$modelRegressor$ev_c
ev_nc_all = model0$modelRegressor$ev_nc
pe_all = model0$modelRegressor$pe
writeMat("model0.mat", ev_c_all = ev_c_all, ev_nc_all = ev_nc_all, pe_all = pe_all)

# Export regressors to matlab
library(R.matlab)
ev_c_all = model1$modelRegressor$ev_c
ev_nc_all = model1$modelRegressor$ev_nc
pe_c_all = model1$modelRegressor$pe_c
pe_nc_all = model1$modelRegressor$pe_nc
dv_all = model1$modelRegressor$dv
writeMat("model1.mat", ev_c_all = ev_c_all, ev_nc_all = ev_nc_all, pe_c_all = pe_c_all, pe_nc_all = pe_nc_all, dv_all = dv_all)

# Export regressors to matlab
library(R.matlab)
model2_ev_c_all = model2$modelRegressor$ev_c
model2_ev_nc_all = model2$modelRegressor$ev_nc
model2_pe_all = model2$modelRegressor$pe
writeMat("model2.mat", model2_ev_c_all = model2_ev_c_all, model2_ev_nc_all = model2_ev_nc_all, model2_pe_all = model2_pe_all)

## Get subject list
subjList = unique(model0$rawdata$subjID)

model0_y_pred = model0$parVals$y_pred
dim(model0_y_pred)
model0_y_pred_mean = apply(model0_y_pred, c(2,3,4), mean)
saveRDS(model0, file = "model0_y_pred_mean.rds")

model1_y_pred = model1$parVals$y_pred
dim(model1_y_pred)
model1_y_pred_mean = apply(model1_y_pred, c(2,3,4), mean)
saveRDS(model0, file = "model1_y_pred_mean.rds")

model2_y_pred = model2$parVals$y_pred
dim(model2_y_pred)
model2_y_pred_mean = apply(model2_y_pred, c(2,3,4), mean)
saveRDS(model0, file = "model2_y_pred_mean.rds")

model3_y_pred = model3$parVals$y_pred
dim(model3_y_pred)
model3_y_pred_mean = apply(model3_y_pred, c(2,3,4), mean)
saveRDS(model0, file = "model3_y_pred_mean.rds")

## PPC

raw_data = model3$rawdata

numSubjs = dim(model3$allIndPars)[1]  # number of subjects
subjList = unique(model3$rawdata$subjID)  # list of subject IDs
maxblock = max(unique(model3$rawdata$block))
maxT = max(table(model3$rawdata$subjID))  # maximum number of trials
true_y <- list()

## true data for each subject
for (i in 1:numSubjs) {
  tmpID = subjList[i]
  blk_1 = subset(model3$rawdata, subjID == tmpID & block == 1)
  blk_2 = subset(model3$rawdata, subjID == tmpID & block == 2)
  blk_3 = subset(model3$rawdata, subjID == tmpID & block == 3)
  blk_4 = subset(model3$rawdata, subjID == tmpID & block == 4)
  choice_list = list(blk_1$choice,blk_2$choice,blk_3$choice,blk_4$choice)
  choice_list$blk1 <- blk_1$choice
  choice_list$blk2 <- blk_2$choice
  true_y[i]$blk1 <- choice_list
}


n = 10
b = 3

tmpData = subset(model3$rawdata, subjID == subjList[n] & block == b)
true_y = tmpData$choice
plot(tmpData$choice, type="l", xlab="Trial", ylab="Choice (1 or 2)", col="black", lty=2, yaxt="n", bty = "L")
axis(2, at = seq(1, 2, .5), labels = seq(1, 2, .5), lwd = 0, lwd.ticks = 1)
lines(model0_y_pred_mean[n, b, ], col="blue")
axis(3, at = seq(1, 2, .5), labels = seq(1, 2, .5), lwd = 0, lwd.ticks = 1)
lines(model2_y_pred_mean[n, b, ], col="red")
axis(4, at = seq(1, 2, .5), labels = seq(1, 2, .5), lwd = 0, lwd.ticks = 1)
lines(model3_y_pred_mean[n, b, ], col="green")
par(xpd=TRUE)
legend("topright", legend=c("Actual response", "Model 0", "Model 2", "Model 3"), inset=c(0.03,-0.1), col=c("black", "blue", "red","green"), lty=c(2, 1, 3, 4), bty = "o")

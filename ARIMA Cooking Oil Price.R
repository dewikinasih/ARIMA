library(TSA) #eacf
library(tseries) # adf test
library(forecast) #forecast,boxcox
library(lmtest) #coeftest

library(readxl)
data = read_excel('harga minyak jkt.xlsx')
plot(data,type='l',main='Harga Minyak Kemasan')

data_test = tail(data$Harga,22)
data_train = head(data$Harga,190)
par(mfrow=c(1,2))
plot(data_train,type='l',main = 'Data Training')
plot(data_test,type='l',main = 'Data Testing')

#uji stasioneritas
BoxCox.lambda(data_train) #ragam
adf.test(data_train) #rataan

acf(data_train)
pacf(data_train)

# differencing sekali ternyata udh stasi mean ragam
train_diff1 = diff(data_train,lag=1)
adf.test(train_diff1)
BoxCox.lambda(train_diff1)

par(mfrow=c(1,1))
plot(train_diff1,type='l')
acf(train_diff1) # signif di lag 1 mungkin MA(1)
pacf(train_diff1) # sig di lag 1 mungkin AR(1)
eacf(train_diff1) # sudut segotoga o di ar 0 dan ma 1
auto.arima(data_train) #gaada package, katanta arima 1 1 1


# model tentatif
model1 = arima(data_train,order=c(1,1,0)) #gaada package
coeftest(model1)

model2 = arima(data_train,order=c(0,1,1))
coeftest(model2)

model3 = arima(data_train,order=c(1,1,1))
coeftest(model3)

# residual model 1 dan 2
sisaan1 = model1$residuals
par(mfrow=c(2,2))
qqnorm(sisaan1)
qqline(sisaan1,col='blue',lwd=2) #garis kenormalan
hist(sisaan1)
Acf(sisaan1)
Pacf(sisaan1)  

shapiro.test(sisaan1) #SISAAN TDK NORMAL KRN p = 0.004 < 0.05
Box.test(sisaan1,lag = 1,type = 'Ljung') #krn p = 0.2 > o.05 maka terima H0 artinya tdk ada korelasi

# analisis residual model 2
sisaan2 = model2$residuals
par(mfrow=c(2,2))
qqnorm(sisaan2)
qqline(sisaan2,col='blue',lwd=2) #garis kenormalan
hist(sisaan2)
acf(sisaan2)
pacf(sisaan2)     

shapiro.test(sisaan2) #SISAAN TDK NORMAL KRN p = 0.02 < 0.05
Box.test(sisaan2,lag = 1,type = 'Ljung') #krn p = 0.7 > o.05 maka terima H0 artinya tdk ada korelasi

model1$aic
model2$aic

# dipilih model 2 ARIMA(0,1,1)
#---------------------------overfitting-----------------------------
model4 = arima(data_train,order=c(2,1,0))
coeftest(model4)

model5 = arima(data_train,order=c(1,1,1)) #naikin orde AR, jadi sama kaya model3

#semua param model tdk signifikan
# tetap digunakan mode1 terbaik td yaitu model2 ARIMA(0,1,1)


#---------------------------------------KEMAMPUAN PEMODELAN------------------------------------

#cek kemampuan pemodelan dgn data training
# plot model vs data
fore = forecast(data_train,model=model2,h=length(data_test))
summary(fore)

train = fore$fitted #fitted value utk data training

par(mfrow=c(1,1))
plot(data_train,type='l', xlab='Hari ke-',ylab='Harga Minyak',main='Plot Data Training')
lines(train,type='l',col='blue')
legend("topleft",legend = c('Data Asli', 'ARIMA(1,1,0)'), fill = c('black', 'blue'))

model = as.numeric(train)
asli = data_train

ab = abs((asli-model)/model)
sum(ab)/length(data_train)*100
#--------------------------------------KEMAMPUAN PERAMALAN--------------------------------------------
#forecast utk data testing
plot(fore)
lines(data$Harga)
ramal = as.data.frame(fore)
f = ramal$'Point Forecast'

accuracy(f,data_test)
model2 = f
asli2 = data_test

ab2 = abs((asli2-model2)/model2)
sum(ab2)/length(data_test)*100

mean(data_test) 
mean(f)

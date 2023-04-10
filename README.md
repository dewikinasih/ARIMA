# ARIMA
Time Series Analysis Project with ARIMA Box-Jenkins Modeling Approach on Cooking Oil Price Data

The data has been taken from Panel Harga Pangan site owned by Badan Pangan Nasional. The time series data used is daily record of cooking oil price in Jakarta Province from November 2021 to May 2022. The aim is to fit ARIMA model based on the pattern of cooking oil price data and then make forecasting for the next 20 days.
I found that the best time series model to fit in the data and predict the data is ARIMA(1,1,0). The model has one significant AR parameter and requires one times differencing to be stationary. The error measure of prediction result is very small, there is only 0,7% of error in the prediction which means ARIMA(1,1,0) really best suits the data  

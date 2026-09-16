
# FAERS Serious Adverse Event Risk Prediction API

## Project Overview

This project uses machine learning to predict whether a newly
received adverse-event report is likely to be Serious or Non-Serious.

The model is deployed as a REST API using FastAPI.

## ML Problem

Binary Classification

Target:
- 0 = Non-Serious
- 1 = Serious

## Model

Logistic Regression with preprocessing implemented using a
Scikit-learn Pipeline.

## API Framework

FastAPI

## API Endpoints

### GET /
Checks whether the API is running.

### GET /health
Checks whether the trained machine learning model has loaded
successfully.

### POST /predict
Accepts adverse-event information and returns the predicted
seriousness and probability.

## Technologies Used

- Python
- Pandas
- NumPy
- Scikit-learn
- Joblib
- FastAPI
- Uvicorn

## Deployment

The API is deployed using Render.


from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import joblib


# --------------------------------------------------
# Create FastAPI application
# --------------------------------------------------

app = FastAPI(
    title="FAERS Serious Adverse Event Risk Prediction API",
    description=(
        "Predicts whether an adverse-event report is "
        "Serious or Non-Serious."
    ),
    version="1.0.0"
)


# --------------------------------------------------
# Load trained ML pipeline
# --------------------------------------------------

MODEL_PATH = "faers_serious_event_model.pkl"

try:
    model = joblib.load(MODEL_PATH)
    print("Model loaded successfully")
except Exception as e:
    print("Error loading model:", e)
    model = None


# --------------------------------------------------
# Define API input schema
# --------------------------------------------------

class ClassificationInput(BaseModel):

    patient_age_years: float
    patient_weight_kg: float
    patient_sex: int

    num_drugs: int
    num_reactions: int

    reporttype: int
    qualification: int

    primarysourcecountry: str
    occurcountry: str
    reportercountry: str

    age_group: str

    valid_weight: int
    polypharmacy_flag: int
    reaction_diversity: int
    country_match_flag: int

    reporting_delay_days: float

    suspect_drug_count: int
    unique_active_substances: int
    unique_indications: int
    drug_route_count: int


# --------------------------------------------------
# Home endpoint
# --------------------------------------------------

@app.get("/")
def home():

    return {
        "message":
        "FAERS Serious Adverse Event Risk Prediction API is running",
        "status": "success"
    }


# --------------------------------------------------
# Health endpoint
# --------------------------------------------------

@app.get("/health")
def health():

    if model is None:

        return {
            "status": "unhealthy",
            "model_loaded": False
        }

    return {
        "status": "healthy",
        "model_loaded": True
    }


# --------------------------------------------------
# Prediction endpoint
# --------------------------------------------------

@app.post("/predict")
def predict(data: ClassificationInput):

    if model is None:

        raise HTTPException(
            status_code=500,
            detail="Model is not loaded"
        )

    try:

        input_data = pd.DataFrame([data.model_dump()])

        prediction = int(
            model.predict(input_data)[0]
        )

        probabilities = model.predict_proba(
            input_data
        )[0]

        serious_probability = float(
            probabilities[1]
        )

        non_serious_probability = float(
            probabilities[0]
        )

        predicted_class = (
            "Serious"
            if prediction == 1
            else "Non-Serious"
        )

        return {
            "prediction": predicted_class,
            "predicted_class": prediction,
            "serious_probability":
                round(serious_probability, 4),
            "non_serious_probability":
                round(non_serious_probability, 4)
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e)
        )

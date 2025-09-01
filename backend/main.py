from fastapi import FastAPI
from pydantic import BaseModel
import joblib, pandas as pd, shap

# Load models
lgbm = joblib.load("./models/lgbm_credit_model.pkl")
xgb = joblib.load("./models/xgb_credit_model.pkl")
feature_cols = joblib.load("./models/feature_cols.pkl")

app = FastAPI(title="Credisense Credit Scoring API")

# ✅ Extended Input schema
class CreditInput(BaseModel):
    Annual_Income: float
    Monthly_Inhand_Salary: float
    Num_Bank_Accounts: int
    Num_Credit_Card: int
    Interest_Rate: float
    Num_of_Loan: int
    Delay_from_due_date: int
    Num_of_Delayed_Payment: int
    Credit_Mix: int
    Outstanding_Debt: float
    Credit_History_Year: int
    Monthly_Balance: float
    upi_txn_count_30d: int
    upi_spend_30d: float
    bill_paid_on_time_rate_90d: float
    late_fee_flag_90d: int
    salary_detected: int
    merchant_diversity_30d: int

    # 🔹 Added missing features
    Age: int
    Occupation: str
    Type_of_Loan: str
    Changed_Credit_Limit: float
    Num_Credit_Inquiries: int
    Credit_Utilization_Ratio: float
    Credit_History_Age: str   # (format: "15 Years 5 Months")
    Payment_of_Min_Amount: str
    Total_EMI_per_month: float
    Amount_invested_monthly: float
    Payment_Behaviour: str
    Credit_History_Months: int


# ✅ Preprocessing function
def preprocess_input(df: pd.DataFrame) -> pd.DataFrame:
    mapping_dict = {
        "Occupation": {
            "Student": 0, "Salaried": 1, "Business Owner": 2,
            "Self-Employed": 3, "Other": 4
        },
        "Type_of_Loan": {
            "Personal Loan": 0, "Home Loan": 1, "Car Loan": 2,
            "Business Loan": 3, "Education Loan": 4, "Other": 5
        },
        "Payment_of_Min_Amount": {"No": 0, "Yes": 1},
        "Payment_Behaviour": {
            "Regular": 2,
            "Regular with occasional delays": 1,
            "Irregular": 0
        }
    }

    # Encode categorical fields
    for col, mapping in mapping_dict.items():
        if col in df.columns:
            df[col] = df[col].map(mapping).fillna(-1).astype(int)

    # Convert Credit_History_Age ("10 Years 6 Months" → months)
    if "Credit_History_Age" in df.columns:
        years = df["Credit_History_Age"].str.extract(r'(\d+)\s*Year')[0].fillna(0).astype(int)
        months = df["Credit_History_Age"].str.extract(r'(\d+)\s*Month')[0].fillna(0).astype(int)
        df["Credit_History_Age"] = years * 12 + months

    return df


@app.post("/predict")
def predict_score(data: CreditInput):
    df = pd.DataFrame([data.dict()])
    df = preprocess_input(df)
    df = df[feature_cols]

    pred_lgbm = float(lgbm.predict(df)[0])
    pred_xgb = float(xgb.predict(df)[0])

    # Classification bands
    if pred_lgbm < 550:
        risk = "Risky"
    elif pred_lgbm < 650:
        risk = "Moderate"
    elif pred_lgbm < 700:
        risk = "Average"
    elif pred_lgbm < 750:
        risk = "Good"
    else:
        risk = "Excellent"

    return {
        "credit_score_lgbm": round(pred_lgbm, 2),
        "credit_score_xgb": round(pred_xgb, 2),
        "risk_category": risk
    }


@app.post("/explain")
def explain_score(data: CreditInput):
    df = pd.DataFrame([data.dict()])
    df = preprocess_input(df)
    df = df[feature_cols]

    explainer = shap.TreeExplainer(lgbm)
    shap_values = explainer.shap_values(df)

    shap_importance = sorted(
        zip(feature_cols, shap_values[0]),
        key=lambda x: abs(x[1]),
        reverse=True
    )[:5]

    return {"shap_explanation": shap_importance}

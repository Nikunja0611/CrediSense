# backend/ai_insights.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import requests
import os, json

app = FastAPI()

# Allow frontend requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

API_KEY = os.getenv("GEMINI_API_KEY", "AIzaSyBSNgAvFq7j5Wlid-V4BhIIJm0rEyjpf7Y")
BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

# Load persona data
with open("assets/mock_persona.json", "r") as f:
    persona_data = json.load(f)


class ChatQuery(BaseModel):
    query: str


@app.post("/chat")
def chat(query: ChatQuery):
    headers = {
        "Content-Type": "application/json",
        "X-goog-api-key": API_KEY,
    }

    # Inject persona data into the system prompt (training the assistant on the fly)
    context_prompt = f"""
    You are CrediSense AI Financial Assistant.
    Always use the following user profile for answers:

    - Name: {persona_data['user']['name']}
    - Credit Score: {persona_data['user']['credit_score']}
    - Profile: {persona_data['user']['profile']}
    - Monthly Income: {persona_data['user']['monthly_income']}
    - Loan History: {", ".join(persona_data['user']['loan_history'])}
    - Persona: {persona_data['persona']['description']}
    - Strengths: {", ".join(persona_data['strengths'])}
    - Weaknesses: {", ".join(persona_data['weaknesses'])}
    - Recommendations: {", ".join(persona_data['recommendations'])}
    - Risk Level: {persona_data['insights']['risk_level']}
    - Financial Health: {persona_data['insights']['financial_health']}
    - Growth Opportunity: {persona_data['insights']['growth_opportunity']}

    Rules:
    - Never say you don’t know the credit score or income.
    - Always answer consistently with the above data.
    - Keep responses clear and professional.
    """

    body = {
        "contents": [
            {
                "parts": [
                    {"text": f"{context_prompt}\n\nUser Question: {query.query}"}
                ]
            }
        ]
    }

    response = requests.post(BASE_URL, headers=headers, json=body)
    data = response.json()

    try:
        reply = data["candidates"][0]["content"]["parts"][0]["text"]
    except Exception:
        reply = f"⚠️ API Error: {data}"

    return {"reply": reply}

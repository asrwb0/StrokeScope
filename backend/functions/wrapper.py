# type: ignore

import json
import os
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()
class GPTWrapper:
    def __init__(self, model: str = "gpt-4.1-mini"):
        self.model = model
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise RuntimeError("OPENAI_API_KEY not found in environment or .env file.")
        self.client = OpenAI(api_key=api_key)

    def explain(self, model_output: dict) -> str:
        data = json.dumps(model_output, indent=2)
        prompt = f"""You are a clinical AI explanation engine.

STRICT RULES:
- Do NOT diagnose or give medical advice
- ONLY use the provided data
- Do NOT hallucinate or infer beyond what is given
- Be conservative and factual

Respond using EXACTLY this format (no extra text):
Finding:
<one sentence describing what the model detected>

Confidence:
<one sentence describing the confidence level and what it means>

Details:
<one or two sentences on the class probabilities>

Safety Note:
<one sentence reminding the user this is not a diagnosis>

DATA:
{data}
"""
        response = self.client.chat.completions.create(
            model=self.model,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.0,
        )
        return response.choices[0].message.content
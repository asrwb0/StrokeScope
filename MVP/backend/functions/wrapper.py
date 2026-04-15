# type: ignore
import json
import os
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")

if not api_key:
    raise RuntimeError("OPENAI_API_KEY not found. Check .env or environment variables.")

client = OpenAI(api_key = api_key)

class GPTWrapper:
    def __init__(self, model: str = "gpt-4.1-mini"):
        self.model = model

    def explain(self, model_output: dict) -> str:
        data = json.dumps(model_output, indent = 2)

        prompt = f"""
You are a clinical AI explanation engine.

STRICT RULES:
- Do NOT diagnose or give medical advice
- ONLY use provided data
- Do NOT hallucinate or infer
- Be conservative and factual

Output format:
Finding:
Confidence:
Details:
Safety Note:

DATA:
{data}
"""

        response = client.responses.create(model = self.model, input = prompt, temperature = 0.0)
        return response.output_text
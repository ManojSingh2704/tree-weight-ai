from datetime import datetime
from typing import Optional

from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(title="Tree Weight AI Backend", version="1.0.0")


class FeedbackPayload(BaseModel):
    scan_id: str
    species: str
    predicted_weight_kg: float = Field(gt=0)
    actual_weight_kg: float = Field(gt=0)
    farm_name: Optional[str] = None
    plot_details: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class FeedbackResponse(BaseModel):
    saved: bool
    error_kg: float
    correction_ratio: float
    received_at: datetime


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/feedback", response_model=FeedbackResponse)
def save_feedback(payload: FeedbackPayload) -> FeedbackResponse:
    """Persist this payload to PostgreSQL/Firebase in production.

    The app stores feedback offline first. When internet is available, sync each
    payload here so the regression model can be retrained or species-specific
    correction factors can be recalculated.
    """

    error_kg = payload.actual_weight_kg - payload.predicted_weight_kg
    correction_ratio = payload.actual_weight_kg / payload.predicted_weight_kg
    return FeedbackResponse(
        saved=True,
        error_kg=error_kg,
        correction_ratio=correction_ratio,
        received_at=datetime.utcnow(),
    )

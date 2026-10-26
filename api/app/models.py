"""Request and response bodies. These also produce the OpenAPI schema."""
from typing import Literal, Optional

from pydantic import BaseModel, Field

ReportingStatus = Literal['new', 'in-progress', 'complete']
ReportingPriority = Literal['low', 'normal', 'high']


class ReportingCreate(BaseModel):
    title: str = Field(min_length=1, max_length=400)
    reference: str = Field(default="", max_length=200)
    status: ReportingStatus = 'new'
    priority: ReportingPriority = 'normal'


class ReportingUpdate(BaseModel):
    title: Optional[str] = Field(default=None, min_length=1, max_length=400)
    reference: Optional[str] = Field(default=None, max_length=200)
    status: Optional[ReportingStatus] = None
    priority: Optional[ReportingPriority] = None


class Reporting(ReportingCreate):
    id: int

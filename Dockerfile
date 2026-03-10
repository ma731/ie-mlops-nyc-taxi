FROM python:3.12-slim

RUN apt-get update -qq && apt-get install -y -qq unzip && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install dependencies from 06-cicd/
COPY 06-cicd/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code and pre-downloaded model (from workflow)
COPY 06-cicd/ .

# Unzip model if artifact uploaded it as a zip
RUN if [ -f models/model.zip ]; then \
      unzip -o models/model.zip -d models/ && rm models/model.zip; \
    fi && echo "Model ready in /app/models"

EXPOSE 9696
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port ${PORT:-9696}"]

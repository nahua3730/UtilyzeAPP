# Utilyze Backend

Step 1 of the wallet flow lives here.

## Setup

1. Copy `.env.example` to `.env`
2. Fill in `HANDCASH_APP_ID` and `HANDCASH_APP_SECRET`
3. Run `npm install`
4. Run `npm run dev`

## Endpoints

- `GET /health`
- `POST /v1/wallet/start-email-code`

Request body:

```json
{
  "email": "user@example.com"
}
```

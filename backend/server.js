import "dotenv/config";
import express from "express";

const app = express();
app.use(express.json());

const { PORT = 3000 } = process.env;

const initialDemoAlerts = [
  {
    id: "alert_001",
    severity: "High",
    title: "Possible water leak",
    bodyShort: "Continuous flow detected for 45 minutes",
    bodyLong:
      "Utilyze detected unusual continuous water usage at this property. Check nearby fixtures, supply lines, and shutoff access as soon as possible.",
    timestamp: new Date(Date.now() - 45 * 60 * 1000).toISOString(),
    dataSummary:
      '{\n  "rule": "continuous_flow",\n  "duration_minutes": 45\n}',
  },
  {
    id: "alert_002",
    severity: "Medium",
    title: "Gas usage anomaly",
    bodyShort: "Usage pattern changed from the normal baseline",
    bodyLong:
      "Utilyze flagged a gas usage pattern that differs from the recent baseline. Review the site to confirm whether the activity is expected.",
    timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
    dataSummary: '{\n  "rule": "baseline_shift",\n  "utility": "gas"\n}',
  },
];

let demoAlerts = [...initialDemoAlerts];

function formattedNow() {
  return `Today at ${new Date().toLocaleTimeString([], {
    hour: "numeric",
    minute: "2-digit",
  })}`;
}

app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

app.post("/v1/wallet/start-email-code", async (req, res) => {
  const email = String(req.body.email || "").trim().toLowerCase();

  if (!email) {
    return res.status(400).json({ error: "email_required" });
  }

  return res.json({
    requestId: `stub_${Date.now()}`,
    delivery: "stubbed",
  });
});

app.post("/v1/wallet/verify-email-code", async (req, res) => {
  const email = String(req.body.email || "").trim().toLowerCase();
  const requestId = String(req.body.requestId || "").trim();
  const code = String(req.body.code || "").trim();
  const username = String(req.body.username || "").trim();

  if (!email || !requestId || !code || !username) {
    return res.status(400).json({ error: "missing_fields" });
  }

  return res.json({
    sessionToken: `stub_session_${username}`,
    userId: `user_${username}`,
    username,
  });
});

app.get("/v1/alerts/feed", async (req, res) => {
  const username = String(req.query.username || "").trim();

  if (!username) {
    return res.status(400).json({ error: "username_required" });
  }

  return res.json({
    alerts: demoAlerts,
  });
});

app.post("/v1/demo/alerts", async (req, res) => {
  const severity = String(req.body.severity || "High").trim();
  const title = String(req.body.title || "Demo water leak alert").trim();
  const bodyShort = String(
    req.body.bodyShort || "Possible leak detected from the Utilyze test flow"
  ).trim();
  const bodyLong = String(
    req.body.bodyLong ||
      "This is a demo alert created by the backend so you can test the Utilyze feed and notification experience without waiting on the HandCash wallet API."
  ).trim();
  const dataSummary = String(
    req.body.dataSummary ||
      '{\n  "rule": "demo_notification",\n  "source": "backend_test_endpoint"\n}'
  ).trim();

  const newAlert = {
    id: `alert_${Date.now()}`,
    severity,
    title,
    bodyShort,
    bodyLong,
    timestamp: new Date().toISOString(),
    dataSummary,
  };

  demoAlerts.unshift(newAlert);

  return res.json({
    alert: newAlert,
  });
});

app.post("/v1/demo/reset-alerts", async (_req, res) => {
  demoAlerts = [...initialDemoAlerts];

  return res.json({
    alerts: demoAlerts,
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Utilyze backend running on http://0.0.0.0:${PORT}`);
});

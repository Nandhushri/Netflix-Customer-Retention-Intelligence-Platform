"""
Netflix Customer Retention Intelligence Platform
================================================
Rule-based AI recommendation engine for churn prevention.
Reads the real Data_netflix.csv — no synthetic data.

Column reference (actual CSV headers):
  Customer ID
  Subscription Length (Months)          → int, 1–24
  Customer Satisfaction Score (1-10)    → int, 1–10
  Daily Watch Time (Hours)              → float, 0.5–5.0
  Engagement Rate (1-10)                → int, 1–10
  Device Used Most Often                → str
  Genre Preference                      → str  (may contain '\\')
  Region                                → str
  Payment History (On-Time/Delayed)     → str  ['On-Time','Delayed']
  Subscription Plan                     → str  ['Basic','Standard','Premium']
  Churn Status (Yes/No)                 → str  ['Yes','No']
  Support Queries Logged                → int, 0–10
  Age                                   → int, 18–70
  Monthly Income ($)                    → int, 510–9994
  Promotional Offers Used               → int, 0–5
  Number of Profiles Created            → int, 1–5
"""

import streamlit as st
import pandas as pd

# ─────────────────────────────────────────────
# PAGE CONFIG  ← must be very first ST call
# ─────────────────────────────────────────────
st.set_page_config(
    page_title="Netflix Retention Intelligence",
    page_icon="🎬",
    layout="wide",
    initial_sidebar_state="expanded",
)

# ─────────────────────────────────────────────
# GLOBAL CSS — Netflix dark palette
# ─────────────────────────────────────────────
st.markdown("""
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=DM+Serif+Display&display=swap');

:root {
  --red:    #E50914;
  --gold:   #F5A623;
  --green:  #1DB954;
  --bg:     #111111;
  --card:   #1A1A1A;
  --card2:  #222222;
  --border: #2A2A2A;
  --text:   #EBEBEB;
  --muted:  #888888;
  --font:   'Inter', sans-serif;
}

html, body, [class*="css"] { font-family: var(--font) !important; }
.stApp               { background: var(--bg) !important; color: var(--text) !important; }

/* Sidebar */
[data-testid="stSidebar"] {
  background: #0A0A0A !important;
  border-right: 1px solid var(--border);
}
[data-testid="stSidebar"] * { color: var(--text) !important; }

/* Selectbox */
.stSelectbox > div > div {
  background: var(--card2) !important;
  border: 1px solid var(--border) !important;
  color: var(--text) !important;
  border-radius: 8px !important;
}

/* Metric */
[data-testid="metric-container"] {
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: 14px;
  padding: 18px 22px !important;
}
[data-testid="metric-container"] label          { color: var(--muted) !important; font-size: 0.72rem !important; letter-spacing: 0.06em; }
[data-testid="stMetricValue"]                   { color: var(--text)  !important; font-size: 1.55rem !important; font-weight: 700 !important; }
[data-testid="stMetricDelta"] svg               { display: none; }

/* Expander */
[data-testid="stExpander"] {
  background: var(--card) !important;
  border: 1px solid var(--border) !important;
  border-radius: 12px !important;
  margin-bottom: 10px;
}
details > summary { color: var(--text) !important; font-weight: 500; }

/* Tables */
.stDataFrame thead tr th { background: var(--card2) !important; color: var(--muted) !important; }
.stDataFrame tbody tr td { background: var(--card)  !important; color: var(--text)  !important; }

hr { border-color: var(--border) !important; }

/* ── Custom classes ─────────────────── */
.page-title {
  font-family: 'DM Serif Display', serif;
  font-size: 1.9rem;
  color: var(--red);
  letter-spacing: -0.3px;
  line-height: 1.1;
  margin: 0;
}
.page-sub {
  font-size: 0.73rem;
  font-weight: 500;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--muted);
  margin-top: 4px;
}

.tag {
  font-size: 0.67rem; font-weight: 600;
  letter-spacing: 0.12em; text-transform: uppercase;
  color: var(--muted); margin: 24px 0 10px;
}

.risk-chip {
  display: inline-flex; align-items: center; gap: 10px;
  padding: 11px 24px; border-radius: 50px;
  font-weight: 700; font-size: 1rem; letter-spacing: 0.04em;
}
.risk-high   { background: rgba(229,9,20,.14);  color:#FF5252; border:1.5px solid rgba(229,9,20,.45); }
.risk-medium { background: rgba(245,166,35,.14); color:#FFAB40; border:1.5px solid rgba(245,166,35,.45); }
.risk-low    { background: rgba(29,185,84,.14);  color:#4CAF83; border:1.5px solid rgba(29,185,84,.45); }

.bar-wrap { background: #2A2A2A; border-radius: 6px; height: 9px; overflow: hidden; margin: 6px 0 3px; }
.bar-fill { height: 100%; border-radius: 6px; }

.rpill {
  display: inline-flex; align-items: center; gap: 6px;
  background: rgba(229,9,20,.1); border: 1px solid rgba(229,9,20,.28);
  border-radius: 20px; padding: 5px 13px;
  font-size: 0.8rem; color: #FF7272; margin: 3px 3px 3px 0;
}

.acard {
  background: var(--card2); border: 1px solid var(--border);
  border-radius: 11px; padding: 13px 17px; margin-bottom: 9px;
  display: flex; align-items: flex-start; gap: 13px;
}
.aicon { font-size: 1.35rem; line-height: 1.3; }
.atitle { font-weight: 600; font-size: 0.91rem; color: var(--text); }
.adesc  { font-size: 0.77rem; color: var(--muted); margin-top: 2px; }

.irow {
  display: flex; justify-content: space-between;
  padding: 9px 0; border-bottom: 1px solid var(--border); font-size: 0.86rem;
}
.ikey { color: var(--muted); }
.ival { color: var(--text); font-weight: 500; }

.sig-box {
  background: var(--card2); border: 1px solid var(--border);
  border-radius: 10px; padding: 12px; text-align: center; margin-bottom: 8px;
}
.sig-icon  { font-size: 1.25rem; }
.sig-label { font-size: 0.66rem; color: var(--muted); margin: 3px 0 2px; }
.sig-badge { font-size: 0.82rem; font-weight: 700; }

.sidebar-logo { font-family: 'DM Serif Display',serif; font-size:1.5rem; color:var(--red); }
.sidebar-tag  { font-size:0.65rem; letter-spacing:0.13em; color:#555; text-transform:uppercase; margin-top:2px; }
.sb-lbl       { font-size:0.66rem; letter-spacing:0.11em; text-transform:uppercase; color:var(--muted); margin-bottom:6px; }
</style>
""", unsafe_allow_html=True)


# ─────────────────────────────────────────────
# DATA LOADING
# Reads the real CSV; cached so Streamlit
# doesn't re-read on every widget interaction.
# ─────────────────────────────────────────────

CSV_PATH = "Data_netflix.csv"   # place CSV in the same folder as app.py

@st.cache_data
def load_data(path: str = CSV_PATH) -> pd.DataFrame:
    """
    Load and lightly clean the Netflix subscriber CSV.
    - Strips whitespace from string columns
    - Replaces '\\' genre values with 'Unknown'
    - Returns a DataFrame sorted by Customer ID
    """
    df = pd.read_csv(path)

    # Normalise string columns
    str_cols = df.select_dtypes("object").columns
    df[str_cols] = df[str_cols].apply(lambda c: c.str.strip())

    # Fix garbage genre value
    df["Genre Preference"] = df["Genre Preference"].replace("\\", "Unknown")

    return df.sort_values("Customer ID").reset_index(drop=True)


# ─────────────────────────────────────────────
# RISK ENGINE
# Scores 0-100 using thresholds calibrated to
# the actual data ranges in Data_netflix.csv:
#   Satisfaction  → 1-10  (mean ≈ 5.4)
#   Engagement    → 1-10  (mean ≈ 5.5)
#   Watch Time    → 0.5-5 hrs  (mean ≈ 2.8)
#   Support       → 0-10  (mean ≈ 5.0)
#   Tenure        → 1-24 months
#   Promos        → 0-5
# ─────────────────────────────────────────────

def evaluate_risk(row: pd.Series) -> dict:
    """
    Evaluate churn risk for one customer.

    Returns dict:
      score   : int 0-100
      level   : 'High' | 'Medium' | 'Low'
      reasons : list[str]  — human-readable risk drivers
      signals : dict       — per-dimension status flags
    """
    score   = 0
    reasons = []
    signals = {}

    # ── 1. Customer Satisfaction (1-10 scale) ──────
    sat = row["Customer Satisfaction Score (1-10)"]
    if sat <= 3:
        score += 28; reasons.append("Very Low Satisfaction Score")
        signals["satisfaction"] = "critical"
    elif sat <= 5:
        score += 15; reasons.append("Below-Average Satisfaction")
        signals["satisfaction"] = "warning"
    elif sat >= 8:
        score -= 6; signals["satisfaction"] = "good"
    else:
        signals["satisfaction"] = "ok"

    # ── 2. Daily Watch Time (0.5–5 hrs) ───────────
    wt = row["Daily Watch Time (Hours)"]
    if wt < 1.0:
        score += 20; reasons.append("Critically Low Watch Time")
        signals["watch_time"] = "critical"
    elif wt < 2.0:
        score += 10; reasons.append("Low Daily Watch Time")
        signals["watch_time"] = "warning"
    elif wt >= 3.5:
        score -= 5; signals["watch_time"] = "good"
    else:
        signals["watch_time"] = "ok"

    # ── 3. Engagement Rate (1-10 scale) ───────────
    er = row["Engagement Rate (1-10)"]
    if er <= 3:
        score += 20; reasons.append("Very Low Engagement Rate")
        signals["engagement"] = "critical"
    elif er <= 5:
        score += 10; reasons.append("Below-Average Engagement")
        signals["engagement"] = "warning"
    elif er >= 8:
        score -= 5; signals["engagement"] = "good"
    else:
        signals["engagement"] = "ok"

    # ── 4. Payment History ─────────────────────────
    pay = row["Payment History (On-Time/Delayed)"]
    if pay == "Delayed":
        score += 18; reasons.append("Delayed Payment History")
        signals["payment"] = "warning"
    else:
        signals["payment"] = "good"

    # ── 5. Support Queries (0-10) ──────────────────
    sq = row["Support Queries Logged"]
    if sq >= 8:
        score += 15; reasons.append("High Volume of Support Queries")
        signals["support"] = "critical"
    elif sq >= 6:
        score += 7; reasons.append("Elevated Support Activity")
        signals["support"] = "warning"
    else:
        signals["support"] = "ok"

    # ── 6. Subscription Length (1-24 months) ───────
    sl = row["Subscription Length (Months)"]
    if sl <= 2:
        score += 12; reasons.append("Very New Subscriber (≤ 2 months)")
        signals["tenure"] = "warning"
    elif sl >= 18:
        score -= 7; signals["tenure"] = "good"
    else:
        signals["tenure"] = "ok"

    # ── 7. Subscription Plan ───────────────────────
    plan = row["Subscription Plan"]
    if plan == "Basic":
        score += 5; signals["plan"] = "warning"
    elif plan == "Premium":
        score -= 5; signals["plan"] = "good"
    else:
        signals["plan"] = "ok"

    # ── 8. Promotional Offers Used (0-5) ───────────
    promo = row["Promotional Offers Used"]
    if promo == 0 and sl > 3:
        score += 6; reasons.append("No Promotional Offers Redeemed")
        signals["promo"] = "warning"
    elif promo >= 4:
        score -= 3; signals["promo"] = "good"
    else:
        signals["promo"] = "ok"

    # Clamp and classify
    score = max(0, min(100, score))
    level = "High" if score >= 52 else ("Medium" if score >= 26 else "Low")

    if not reasons:
        reasons = ["No significant churn signals — customer appears healthy"]

    return {"score": score, "level": level, "reasons": reasons, "signals": signals}


# ─────────────────────────────────────────────
# ACTION CATALOGUE
# 10 retention actions with icon + description
# ─────────────────────────────────────────────

ACTIONS = {
    "retention_email":    {"icon": "📧", "title": "Send Personalised Retention Email",
                           "desc": "Craft a targeted message highlighting the customer's preferred genre and upcoming releases."},
    "discount":           {"icon": "🏷️", "title": "Offer Personalised Discount",
                           "desc": "Provide a 20–30% discount on the next billing cycle to incentivise renewal."},
    "premium_trial":      {"icon": "⭐", "title": "Offer Free Premium Trial",
                           "desc": "Upgrade to Premium for 30 days at no cost — showcase 4K content and extra screens."},
    "genre_recs":         {"icon": "🎬", "title": "Recommend Popular Titles in Preferred Genre",
                           "desc": "Surface trending shows matching the customer's genre preference to re-spark interest."},
    "priority_support":   {"icon": "🎧", "title": "Assign Priority Customer Support",
                           "desc": "Route to a dedicated retention specialist to resolve outstanding issues quickly."},
    "upsell_premium":     {"icon": "🚀", "title": "Upsell to Premium Plan",
                           "desc": "Present a compelling upgrade offer — exclusive content, better quality, more screens."},
    "payment_assist":     {"icon": "💳", "title": "Activate Payment Recovery Flow",
                           "desc": "Send a payment reminder with flexible billing options (EMI, alternate methods)."},
    "reward_loyalty":     {"icon": "🏆", "title": "Reward Loyal Customer",
                           "desc": "Grant bonus credits, ad-free viewing, or exclusive early-access content as a thank-you."},
    "promo_push":         {"icon": "🎁", "title": "Push Relevant Promotional Offers",
                           "desc": "Send curated promos (bundle deals, referral bonuses) to drive re-engagement."},
    "content_nudge":      {"icon": "📱", "title": "Send Content Discovery Nudge",
                           "desc": "Trigger a push notification with 3 personalised top-picks to bring the user back."},
}


def generate_recommendations(row: pd.Series, signals: dict, level: str) -> list[dict]:
    """
    Map risk signals → prioritised retention actions.
    Returns up to 5 action dicts from ACTIONS catalogue.
    """
    chosen = []

    def add(key):
        """Append action only once."""
        if key in ACTIONS and ACTIONS[key] not in chosen:
            chosen.append(ACTIONS[key])

    # Genre recommendation is universally relevant
    add("genre_recs")

    # Satisfaction-driven actions
    if signals.get("satisfaction") == "critical":
        add("retention_email"); add("discount"); add("priority_support")
    elif signals.get("satisfaction") == "warning":
        add("retention_email"); add("premium_trial")

    # Low engagement / watch time → content nudge
    if signals.get("watch_time") in ("critical", "warning") \
       or signals.get("engagement") in ("critical", "warning"):
        add("content_nudge")

    # Delayed payments → payment recovery
    if signals.get("payment") == "warning":
        add("payment_assist"); add("discount")

    # High support volume → priority support
    if signals.get("support") in ("critical", "warning"):
        add("priority_support")

    # Basic plan → upsell / trial
    if signals.get("plan") == "warning":
        add("upsell_premium"); add("premium_trial")

    # No promos redeemed → push promos
    if signals.get("promo") == "warning":
        add("promo_push")

    # Loyal long-tenure customers
    if signals.get("tenure") == "good" and level != "High":
        add("reward_loyalty")

    # Low-risk fallback — just keep them happy
    if level == "Low":
        chosen = [ACTIONS["reward_loyalty"], ACTIONS["genre_recs"], ACTIONS["content_nudge"]]

    return chosen[:5]


# ─────────────────────────────────────────────
# HTML HELPERS
# ─────────────────────────────────────────────

def risk_chip_html(level: str, score: int) -> str:
    cls  = {"High": "risk-high", "Medium": "risk-medium", "Low": "risk-low"}[level]
    icon = {"High": "🔴",        "Medium": "🟡",           "Low": "🟢"}[level]
    return f'<span class="risk-chip {cls}">{icon}&nbsp; {level} Risk &nbsp;·&nbsp; Score {score} / 100</span>'


def reasons_html(reasons: list[str]) -> str:
    pills = "".join(f'<span class="rpill">⚠ {r}</span>' for r in reasons)
    return f'<div style="margin-top:8px;line-height:2.2">{pills}</div>'


def action_card_html(a: dict) -> str:
    return (f'<div class="acard"><div class="aicon">{a["icon"]}</div>'
            f'<div><div class="atitle">{a["title"]}</div>'
            f'<div class="adesc">{a["desc"]}</div></div></div>')


def irow_html(key: str, val) -> str:
    return f'<div class="irow"><span class="ikey">{key}</span><span class="ival">{val}</span></div>'


def section_tag(text: str):
    st.markdown(f'<div class="tag">{text}</div>', unsafe_allow_html=True)


# ─────────────────────────────────────────────
# SIDEBAR
# ─────────────────────────────────────────────

def render_sidebar(df: pd.DataFrame) -> str:
    """Render sidebar and return selected Customer ID."""
    with st.sidebar:
        st.markdown("""
        <div style="padding:18px 0 10px">
          <div class="sidebar-logo">🎬 NCRIP</div>
          <div class="sidebar-tag">Customer Retention Intelligence</div>
        </div>
        <hr style="margin:0 0 20px">
        """, unsafe_allow_html=True)

        st.markdown('<div class="sb-lbl">Select Customer</div>', unsafe_allow_html=True)
        ids = df["Customer ID"].tolist()
        selected = st.selectbox("", ids, label_visibility="collapsed")

        st.markdown("<br>", unsafe_allow_html=True)
        st.markdown('<div class="sb-lbl">Dataset Overview</div>', unsafe_allow_html=True)

        total   = len(df)
        churned = (df["Churn Status (Yes/No)"] == "Yes").sum()

        st.metric("Total Customers",   total)
        st.metric("Churned Customers", int(churned))
        st.metric("Churn Rate",        f"{churned / total * 100:.1f}%")

        st.markdown("<br>", unsafe_allow_html=True)
        st.markdown('<div class="sb-lbl">Risk Legend</div>', unsafe_allow_html=True)
        st.markdown("""
        <div style="font-size:0.79rem;line-height:2.1">
          🔴 &nbsp;<b>High Risk</b> — Score ≥ 52<br>
          🟡 &nbsp;<b>Medium Risk</b> — Score 26–51<br>
          🟢 &nbsp;<b>Low Risk</b> — Score &lt; 26
        </div>
        """, unsafe_allow_html=True)

    return selected


# ─────────────────────────────────────────────
# MAIN DASHBOARD
# ─────────────────────────────────────────────

def render_dashboard(customer: pd.Series):
    """Render the full analysis page for one customer."""

    # ── Evaluate risk + build recommendations ────
    risk    = evaluate_risk(customer)
    actions = generate_recommendations(customer, risk["signals"], risk["level"])

    # ── Page header ──────────────────────────────
    st.markdown("""
    <div style="padding: 22px 0 6px">
      <div class="page-title">Netflix Customer Retention Intelligence Platform</div>
      <div class="page-sub">AI-Powered Churn Prevention &nbsp;·&nbsp; Rule-Based Engine &nbsp;·&nbsp; 1,000 Subscribers</div>
    </div>
    <hr style="margin: 10px 0 24px">
    """, unsafe_allow_html=True)

    # ── KPI strip — 5 key metrics ────────────────
    k1, k2, k3, k4, k5 = st.columns(5)

    sat = customer["Customer Satisfaction Score (1-10)"]
    k1.metric("Satisfaction Score",
              f"{sat} / 10",
              delta="High ✓" if sat >= 7 else "Low ✗",
              delta_color="normal" if sat >= 7 else "inverse")

    wt = customer["Daily Watch Time (Hours)"]
    k2.metric("Daily Watch Time",
              f"{wt} hrs",
              delta="Active ✓" if wt >= 2.0 else "Low ✗",
              delta_color="normal" if wt >= 2.0 else "inverse")

    er = customer["Engagement Rate (1-10)"]
    k3.metric("Engagement Rate",
              f"{er} / 10",
              delta="High ✓" if er >= 6 else "Low ✗",
              delta_color="normal" if er >= 6 else "inverse")

    k4.metric("Tenure", f"{customer['Subscription Length (Months)']} mo.")

    sq = customer["Support Queries Logged"]
    k5.metric("Support Queries",
              str(sq),
              delta="High ✗" if sq >= 8 else None,
              delta_color="inverse" if sq >= 8 else "normal")

    st.markdown("<br>", unsafe_allow_html=True)

    # ── Two-column body ──────────────────────────
    left, right = st.columns([1, 1.08], gap="large")

    # ─── LEFT ────────────────────────────────────
    with left:

        # Customer profile
        section_tag("Customer Profile")
        with st.expander(f"👤  {customer['Customer ID']}  —  Full Details", expanded=True):
            churn_label = "🚨 Churned" if customer["Churn Status (Yes/No)"] == "Yes" else "✅ Active"
            fields = {
                "Customer ID":          customer["Customer ID"],
                "Age":                  f"{customer['Age']} years",
                "Region":               customer["Region"],
                "Monthly Income":       f"${customer['Monthly Income ($)']:,}",
                "Subscription Plan":    customer["Subscription Plan"],
                "Device Used":          customer["Device Used Most Often"],
                "Genre Preference":     customer["Genre Preference"],
                "Payment History":      customer["Payment History (On-Time/Delayed)"],
                "Profiles Created":     customer["Number of Profiles Created"],
                "Promotions Used":      customer["Promotional Offers Used"],
                "Churn Status":         churn_label,
            }
            st.markdown("".join(irow_html(k, v) for k, v in fields.items()),
                        unsafe_allow_html=True)

        # Risk level
        section_tag("Risk Assessment")
        st.markdown(risk_chip_html(risk["level"], risk["score"]),
                    unsafe_allow_html=True)
        st.markdown("<br>", unsafe_allow_html=True)

        # Risk progress bar
        bar_color = {"High": "#E50914", "Medium": "#F5A623", "Low": "#1DB954"}[risk["level"]]
        st.markdown(f"""
        <div style="margin:6px 0 2px;font-size:0.73rem;color:#666">Composite Risk Score</div>
        <div class="bar-wrap">
          <div class="bar-fill" style="width:{risk['score']}%;background:{bar_color}"></div>
        </div>
        <div style="font-size:0.71rem;color:#555;margin-bottom:6px">{risk['score']} / 100</div>
        """, unsafe_allow_html=True)

        # Risk reasons
        section_tag("Risk Drivers")
        st.markdown(reasons_html(risk["reasons"]), unsafe_allow_html=True)

    # ─── RIGHT ───────────────────────────────────
    with right:

        section_tag("Recommended Retention Actions")
        st.markdown("""
        <div style="font-size:0.77rem;color:#666;margin-bottom:14px">
          Ranked by impact priority based on detected risk signals.
        </div>""", unsafe_allow_html=True)

        for action in actions:
            st.markdown(action_card_html(action), unsafe_allow_html=True)

        # Signal health grid
        st.markdown("<br>", unsafe_allow_html=True)
        section_tag("Signal Health Snapshot")

        SIG_META = {
            "satisfaction": ("Satisfaction", "😊"),
            "watch_time":   ("Watch Time",   "⏱️"),
            "engagement":   ("Engagement",   "📊"),
            "payment":      ("Payment",      "💳"),
            "support":      ("Support",      "🎧"),
            "tenure":       ("Tenure",       "📅"),
            "plan":         ("Plan Tier",    "💎"),
            "promo":        ("Promos",       "🎁"),
        }
        STATUS_COLOR  = {"good":"#1DB954","ok":"#666","warning":"#F5A623","critical":"#E50914"}
        STATUS_SYMBOL = {"good":"✓","ok":"–","warning":"!","critical":"✕"}

        cols = st.columns(4)
        for i, (key, (label, icon)) in enumerate(SIG_META.items()):
            s      = risk["signals"].get(key, "ok")
            color  = STATUS_COLOR[s]
            symbol = STATUS_SYMBOL[s]
            with cols[i % 4]:
                st.markdown(f"""
                <div class="sig-box">
                  <div class="sig-icon">{icon}</div>
                  <div class="sig-label">{label}</div>
                  <div class="sig-badge" style="color:{color}">{symbol}</div>
                </div>""", unsafe_allow_html=True)

    # ── Raw data row ─────────────────────────────
    st.markdown("<br>", unsafe_allow_html=True)
    section_tag("Raw Customer Record")
    # Raw data row
    with st.expander("📋  View Raw Data Row"):
        st.markdown("<br>".join(f"**{col}:** {customer[col]}" for col in customer.index), unsafe_allow_html=True)


# ─────────────────────────────────────────────
# ENTRY POINT
# ─────────────────────────────────────────────

def main():
    df          = load_data()           # load real CSV
    selected_id = render_sidebar(df)    # sidebar → chosen customer ID
    customer    = df[df["Customer ID"] == selected_id].iloc[0]
    render_dashboard(customer)          # full analysis page


if __name__ == "__main__":
    main()
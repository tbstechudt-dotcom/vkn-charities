# VKN Charities — Website

**Live preview:** https://tbstechudt-dotcom.github.io/vkn-charities/
(published by GitHub Pages from the `docs/` folder — a compiled Flutter build, base href `/vkn-charities/`;
the forms need the Node API + Supabase, so they don't submit on the static preview).

To update the preview:

```bash
cd frontend
flutter build web --release --base-href /vkn-charities/ -o ../docs
cp ../docs/index.html ../docs/404.html && touch ../docs/.nojekyll && rm -f ../docs/_redirects
```

A five-page website for **VKN Charities** (Coimbatore / Pollachi, Tamil Nadu) and its affiliated U.S. entity **VKN Charities Inc.** (Louisville, KY).

| Layer     | Tech                         | Folder      |
|-----------|------------------------------|-------------|
| Front end | Flutter Web (go_router)      | `frontend/` |
| API       | Node.js + Express            | `backend/`  |
| Database  | Supabase (Postgres + RLS)    | `supabase/` |

```
Browser (Flutter web)  ──►  Node.js API (/api/*)  ──►  Supabase
                                 │
                                 └─ (optional) also serves the Flutter build
```

The Supabase **service role key stays on the Node server only**. The Flutter app never talks to Supabase directly, so no database keys are shipped to the browser.

## Pages

| Route           | Page          | What's on it |
|-----------------|---------------|--------------|
| `/`             | Home          | Hero, key facts, focus areas, approach & founder, India/USA presence, call to action |
| `/about`        | About Us      | Story, founder (Dr. Krishna Nadar), vision & mission, values, milestones (2020 → 12A → 80G → 501(c)(3)) |
| `/programs`     | Our Work      | Programmes loaded **live from Supabase** with category filter, Pollachi initiative, how we work |
| `/usa`          | VKN USA       | VKN Charities Inc. key facts (EIN, 501(c)(3)), stated mission, FY 2024 Form 990-EZ snapshot |
| `/get-involved` | Get Involved  | Donation pledge form, volunteer sign-up, contact form — all saved to Supabase |

## API endpoints

| Method | Path                    | Supabase table      |
|--------|-------------------------|---------------------|
| GET    | `/api/health`           | –                   |
| GET    | `/api/programs`         | `programs` (read)   |
| POST   | `/api/contact`          | `contact_messages`  |
| POST   | `/api/volunteer`        | `volunteers`        |
| POST   | `/api/donation-pledge`  | `donation_pledges`  |

Inputs are validated server-side, request bodies are capped at 20 KB, and form posts are rate-limited (15 per hour per IP).

---

## Setup

### 1. Supabase
1. Create a project at supabase.com.
2. Open **SQL Editor → New query**, paste `supabase/schema.sql`, and click **Run**. This creates the tables, Row Level Security, and seeds the 8 programmes.
3. Copy **Project URL** and the **service_role** key from **Project Settings → API**.

### 2. Node.js API
```bash
cd backend
cp .env.example .env      # then fill SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY
npm install
npm run dev               # http://localhost:3000/api/health
```
Without Supabase keys the API still runs: `/api/programs` returns built-in data and forms reply "not configured yet".

### 3. Flutter web
```bash
cd frontend
flutter create . --platforms web   # first time only: generates missing platform files (keeps lib/ and web/index.html)
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

### 4. Production build
**Option A — one server (simplest).** Build Flutter, then let Node serve it:
```bash
cd frontend && flutter build web --release      # API_BASE_URL empty = same origin
cd ../backend && npm start                      # FLUTTER_BUILD_DIR=../frontend/build/web in .env
```
Deploy `backend/` + `frontend/build/web` to Render, Railway, a VPS, etc.

**Option B — separate hosting.** Host `frontend/build/web` on Firebase Hosting / Netlify / Vercel (add a rewrite of all routes to `/index.html`), and the API anywhere Node runs:
```bash
flutter build web --release --dart-define=API_BASE_URL=https://api.your-domain.org
```
Set `ALLOWED_ORIGINS` in `backend/.env` to your website's address.

---

## Editing content

- **Programmes:** edit rows in the Supabase `programs` table (title, summary, location, `icon`, `sort_order`, `is_published`). Changes appear on *Our Work* without a rebuild. Icon keys: `spa, self_improvement, eco, healing, elderly, child_care, school, park, volunteer`.
- **Contact details** (email, phone, address): `frontend/lib/config.dart`.
- **Colours & fonts:** `frontend/lib/theme.dart`.
- **Founder photo:** add `frontend/assets/founder.jpg`, list it under `flutter: assets:` in `pubspec.yaml`, and swap the placeholder icon in `lib/pages/about_page.dart`.

## Viewing submissions
Supabase → **Table Editor** → `contact_messages`, `volunteers`, `donation_pledges`. Each row has a `status` column you can update as you follow up.

## Before going live — please check
- Replace the placeholder email and phone in `config.dart`, and confirm the address.
- Confirm all registration details and the FY 2024 figures against the original certificates and the filed Form 990-EZ.
- The donation form records **pledges only**; no payment is taken. To accept online payments later, add Razorpay (India) / Stripe or PayPal (USA) on the Node server.

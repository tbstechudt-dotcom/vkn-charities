import 'dotenv/config';
import fs from 'node:fs';
import path from 'node:path';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { apiRouter } from './routes.js';

const app = express();
const PORT = Number(process.env.PORT) || 3000;

app.set('trust proxy', 1);
app.disable('x-powered-by');

// Flutter web needs inline scripts / wasm, so relax CSP for the static site.
app.use(helmet({ contentSecurityPolicy: false, crossOriginEmbedderPolicy: false }));

const allowed = (process.env.ALLOWED_ORIGINS || '')
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);
app.use(cors({ origin: allowed.length ? allowed : true }));

app.use(express.json({ limit: '20kb' }));

// General limiter for the whole API + a stricter one for form submissions.
app.use('/api', rateLimit({ windowMs: 15 * 60 * 1000, limit: 300, standardHeaders: 'draft-7', legacyHeaders: false }));
const writeLimiter = rateLimit({
  windowMs: 60 * 60 * 1000,
  limit: 15,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
  message: { error: 'Too many submissions from this device. Please try again later.' },
});

app.use('/api', apiRouter(writeLimiter));
app.use('/api', (_req, res) => res.status(404).json({ error: 'Not found' }));

// Optionally host the Flutter web build from the same server.
const buildDir = process.env.FLUTTER_BUILD_DIR
  ? path.resolve(process.cwd(), process.env.FLUTTER_BUILD_DIR)
  : null;
if (buildDir && fs.existsSync(path.join(buildDir, 'index.html'))) {
  // Flutter web file names are not content-hashed (main.dart.js, assets/...), so
  // browsers must revalidate on every visit or they keep showing an old build.
  // ETags make unchanged files a cheap 304 response.
  app.use(express.static(buildDir, {
    index: false,
    etag: true,
    lastModified: true,
    setHeaders: (res) => res.setHeader('Cache-Control', 'no-cache'),
  }));
  // SPA fallback so /about, /programs, etc. load the Flutter app.
  app.get('*', (_req, res) => {
    res.setHeader('Cache-Control', 'no-cache');
    res.sendFile(path.join(buildDir, 'index.html'));
  });
  console.log(`[web] serving Flutter build from ${buildDir}`);
}

// Error handler — never leak stack traces to the browser.
// eslint-disable-next-line no-unused-vars
app.use((err, _req, res, _next) => {
  const status = err.status || (err.type === 'entity.parse.failed' ? 400 : 500);
  if (status >= 500) console.error(err);
  res.status(status).json({ error: status >= 500 && !err.status ? 'Internal server error' : err.message });
});

app.listen(PORT, () => console.log(`VKN Charities API listening on http://localhost:${PORT}`));

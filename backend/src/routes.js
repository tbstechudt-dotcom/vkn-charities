import { Router } from 'express';
import { supabase, supabaseConfigured } from './supabase.js';
import { fallbackPrograms } from './fallbackPrograms.js';
import { str, email, phone, oneOf, positiveAmount } from './validate.js';

/** Wrap async handlers so errors reach the error middleware. */
const wrap = (fn) => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

function requireDb() {
  if (!supabaseConfigured) {
    const err = new Error('The form service is not configured yet. Please email us directly.');
    err.status = 503;
    throw err;
  }
}

async function insert(table, row) {
  requireDb();
  const { error } = await supabase.from(table).insert(row);
  if (error) {
    console.error(`[supabase] insert into ${table} failed:`, error.message);
    const err = new Error('We could not save your submission. Please try again later.');
    err.status = 502;
    throw err;
  }
}

export function apiRouter(writeLimiter) {
  const r = Router();

  r.get('/health', (_req, res) => {
    res.json({ ok: true, supabase: supabaseConfigured, time: new Date().toISOString() });
  });

  // ---- Programmes (Our Work page) ----------------------------------
  r.get('/programs', wrap(async (_req, res) => {
    if (!supabaseConfigured) return res.json({ data: fallbackPrograms, source: 'fallback' });

    const { data, error } = await supabase
      .from('programs')
      .select('slug,title,category,summary,location,icon')
      .eq('is_published', true)
      .order('sort_order', { ascending: true });

    if (error || !data?.length) {
      if (error) console.error('[supabase] programs:', error.message);
      return res.json({ data: fallbackPrograms, source: 'fallback' });
    }
    res.set('Cache-Control', 'public, max-age=300');
    res.json({ data, source: 'supabase' });
  }));

  // ---- Contact form -------------------------------------------------
  r.post('/contact', writeLimiter, wrap(async (req, res) => {
    const b = req.body;
    const row = {
      name: str(b, 'name', { required: true, max: 120, label: 'Name' }),
      email: email(b),
      phone: phone(b),
      subject: str(b, 'subject', { max: 150, label: 'Subject' }),
      message: str(b, 'message', { required: true, max: 3000, label: 'Message' }),
    };
    await insert('contact_messages', row);
    res.status(201).json({ ok: true, message: 'Thank you! We will get back to you soon.' });
  }));

  // ---- Volunteer sign-up -------------------------------------------
  r.post('/volunteer', writeLimiter, wrap(async (req, res) => {
    const b = req.body;
    const row = {
      name: str(b, 'name', { required: true, max: 120, label: 'Name' }),
      email: email(b),
      phone: phone(b, 'phone', { required: true }),
      city: str(b, 'city', { max: 80, label: 'City' }),
      interest: str(b, 'interest', { max: 80, label: 'Area of interest' }),
      availability: str(b, 'availability', { max: 80, label: 'Availability' }),
      message: str(b, 'message', { max: 2000, label: 'Message' }),
    };
    await insert('volunteers', row);
    res.status(201).json({ ok: true, message: 'Thank you for offering your time! Our team will contact you.' });
  }));

  // ---- Donation pledge ---------------------------------------------
  r.post('/donation-pledge', writeLimiter, wrap(async (req, res) => {
    const b = req.body;
    const entity = oneOf(b, 'entity', ['india', 'usa'], { label: 'Organisation' });
    const row = {
      name: str(b, 'name', { required: true, max: 120, label: 'Name' }),
      email: email(b),
      phone: phone(b),
      entity,
      currency: entity === 'usa' ? 'USD' : 'INR',
      amount: positiveAmount(b),
      purpose: str(b, 'purpose', { max: 80, label: 'Purpose' }),
      message: str(b, 'message', { max: 2000, label: 'Message' }),
    };
    await insert('donation_pledges', row);
    res.status(201).json({
      ok: true,
      message: 'Thank you for your generosity! We will email you the payment and receipt details.',
    });
  }));

  return r;
}

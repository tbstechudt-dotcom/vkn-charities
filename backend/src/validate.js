// Small, dependency-free validation helpers.

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
const PHONE_RE = /^[+0-9()\-\s]{6,20}$/;

export class ValidationError extends Error {
  constructor(message) {
    super(message);
    this.status = 400;
  }
}

/** Trim a string field and enforce required / max length. */
export function str(body, field, { required = false, max = 500, label = field } = {}) {
  const raw = body?.[field];
  const value = typeof raw === 'string' ? raw.trim() : raw == null ? '' : String(raw).trim();
  if (required && !value) throw new ValidationError(`${label} is required.`);
  if (value.length > max) throw new ValidationError(`${label} must be ${max} characters or fewer.`);
  return value || null;
}

export function email(body, field = 'email') {
  const value = str(body, field, { required: true, max: 254, label: 'Email' });
  if (!EMAIL_RE.test(value)) throw new ValidationError('Please enter a valid email address.');
  return value.toLowerCase();
}

export function phone(body, field = 'phone', { required = false } = {}) {
  const value = str(body, field, { required, max: 20, label: 'Phone' });
  if (value && !PHONE_RE.test(value)) throw new ValidationError('Please enter a valid phone number.');
  return value;
}

export function oneOf(body, field, allowed, { label = field } = {}) {
  const value = str(body, field, { required: true, max: 50, label });
  if (!allowed.includes(value)) throw new ValidationError(`${label} is not valid.`);
  return value;
}

export function positiveAmount(body, field = 'amount') {
  const n = Number(body?.[field]);
  if (!Number.isFinite(n) || n <= 0) throw new ValidationError('Please enter a valid amount.');
  if (n > 100000000) throw new ValidationError('Amount is too large.');
  return Math.round(n * 100) / 100;
}

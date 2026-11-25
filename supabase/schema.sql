-- =====================================================================
-- VKN Charities — Supabase schema
-- Run this in Supabase Dashboard → SQL Editor → New query → Run
-- =====================================================================

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------
-- Programmes shown on the "Our Work" page (editable from the dashboard)
-- ---------------------------------------------------------------------
create table if not exists public.programs (
  id           uuid primary key default gen_random_uuid(),
  slug         text unique not null,
  title        text not null,
  category     text not null,          -- e.g. 'Healing', 'Care', 'Education'
  summary      text not null,
  location     text,                   -- e.g. 'Pollachi, Tamil Nadu'
  icon         text default 'spa',     -- icon key used by the Flutter app
  sort_order   int  default 100,
  is_published boolean default true,
  created_at   timestamptz default now()
);

-- ---------------------------------------------------------------------
-- Contact form messages
-- ---------------------------------------------------------------------
create table if not exists public.contact_messages (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  email      text not null,
  phone      text,
  subject    text,
  message    text not null,
  status     text default 'new' check (status in ('new','in_progress','closed')),
  created_at timestamptz default now()
);

-- ---------------------------------------------------------------------
-- Volunteer sign-ups
-- ---------------------------------------------------------------------
create table if not exists public.volunteers (
  id           uuid primary key default gen_random_uuid(),
  name         text not null,
  email        text not null,
  phone        text,
  city         text,
  interest     text,                   -- yoga, elder care, children, etc.
  availability text,
  message      text,
  status       text default 'new' check (status in ('new','contacted','onboarded','declined')),
  created_at   timestamptz default now()
);

-- ---------------------------------------------------------------------
-- Donation pledges (no payment is taken on the website;
-- the office follows up with bank / receipt details)
-- ---------------------------------------------------------------------
create table if not exists public.donation_pledges (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  email      text not null,
  phone      text,
  entity     text not null check (entity in ('india','usa')),
  currency   text not null check (currency in ('INR','USD')),
  amount     numeric(12,2) not null check (amount > 0),
  purpose    text,
  message    text,
  status     text default 'pledged' check (status in ('pledged','received','receipted','cancelled')),
  created_at timestamptz default now()
);

-- ---------------------------------------------------------------------
-- Row Level Security
-- The Node.js API uses the SERVICE ROLE key (bypasses RLS) for inserts.
-- The public anon key can only read published programmes.
-- ---------------------------------------------------------------------
alter table public.programs          enable row level security;
alter table public.contact_messages  enable row level security;
alter table public.volunteers        enable row level security;
alter table public.donation_pledges  enable row level security;

drop policy if exists "Public can read published programs" on public.programs;
create policy "Public can read published programs"
  on public.programs for select
  using (is_published = true);

-- No anon policies on the form tables = no public read/write.

-- ---------------------------------------------------------------------
-- Seed programmes
-- ---------------------------------------------------------------------
insert into public.programs (slug, title, category, summary, location, icon, sort_order) values
  ('holistic-healing', 'Holistic Healing Centres', 'Healing',
   'Integrated care that brings together traditional and complementary therapies to support the whole person — body, mind and spirit.',
   'Puravipalayam, Pollachi', 'spa', 10),
  ('yoga-meditation', 'Yoga & Meditation Retreats', 'Wellbeing',
   'Guided yoga, pranayama and meditation sessions and retreats for stress relief, inner balance and healthy living.',
   'Coimbatore & Pollachi', 'self_improvement', 20),
  ('ayurveda-siddha', 'Ayurveda & Siddha', 'Healing',
   'Awareness and access to India''s time-honoured systems of medicine, including Tamil Nadu''s own Siddha tradition.',
   'Tamil Nadu', 'eco', 30),
  ('alternative-therapies', 'Alternative Therapies', 'Healing',
   'Natural and complementary treatment approaches offered alongside guidance on healthy lifestyle and diet.',
   'Tamil Nadu', 'healing', 40),
  ('elder-care', 'Care for Orphaned Elders', 'Care',
   'Shelter, companionship, nutrition and health support for elderly people who have no one to care for them.',
   'Coimbatore', 'elderly', 50),
  ('children', 'Care for Orphaned Children', 'Care',
   'A safe, loving environment for children in need, with food, health care and a foundation for the future.',
   'Coimbatore', 'child_care', 60),
  ('education', 'Education', 'Education',
   'Learning support and value-based education that helps children and young people build a better future.',
   'Tamil Nadu', 'school', 70),
  ('relief-recharge', 'Relief & Recharge Centres', 'Wellbeing',
   'Calm spaces where people can rest, restore and recover their energy and wellbeing.',
   'Planned', 'park', 80)
on conflict (slug) do nothing;

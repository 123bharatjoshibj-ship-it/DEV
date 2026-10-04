-- Run in Supabase -> SQL Editor (safe to run more than once)
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  sku text unique not null,
  name text not null,
  price numeric(10,2) not null check (price >= 0),
  created_at timestamptz default now()
);
alter table public.products
  add column if not exists cost numeric(10,2) default 0,
  add column if not exists stock numeric(12,3),
  add column if not exists min_stock numeric(12,3) default 0,
  add column if not exists expiry date;

create table if not exists public.sales (
  id uuid primary key,
  invoice_no text unique not null,
  items jsonb not null,
  total numeric(10,2) not null,
  payment_mode text not null check (payment_mode in ('UPI','CASH','KHATA')),
  customer_name text,
  created_at timestamptz not null default now()
);
alter table public.sales
  add column if not exists subtotal numeric(10,2),
  add column if not exists discount numeric(10,2) default 0,
  add column if not exists customer_key text;

create table if not exists public.payments (
  id uuid primary key,
  customer text not null,
  customer_name text,
  amount numeric(10,2) not null,
  note text,
  created_at timestamptz not null default now()
);

create table if not exists public.customers (
  k text primary key,
  name text not null,
  phone text
);

alter table public.products enable row level security;
alter table public.sales enable row level security;
alter table public.payments enable row level security;
alter table public.customers enable row level security;

drop policy if exists "anon all products" on public.products;
drop policy if exists "anon all sales" on public.sales;
drop policy if exists "anon all payments" on public.payments;
drop policy if exists "anon all customers" on public.customers;
create policy "anon all products" on public.products for all to anon using (true) with check (true);
create policy "anon all sales" on public.sales for all to anon using (true) with check (true);
create policy "anon all payments" on public.payments for all to anon using (true) with check (true);
create policy "anon all customers" on public.customers for all to anon using (true) with check (true);

insert into public.products (sku, name, price, cost, stock, min_stock) values
 ('CM-001','Classic Milds',20,18,50,10),
 ('GFL-001','Gold Flake Lights',20,18,50,10),
 ('MR-001','Marlboro Red',25,22,50,10),
 ('MB-001','Matchbox',2,1.5,100,20)
on conflict (sku) do nothing;

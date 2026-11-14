-- Ujjwal Picks feature migration. Run ONCE in Supabase SQL Editor.
-- Safe additive migration: keeps existing products, settings, users and storage intact.

alter table public.products
  add column if not exists is_trending boolean not null default false;

create table if not exists public.product_clicks (
  id bigint generated always as identity primary key,
  product_id uuid not null references public.products(id) on delete cascade,
  visitor_id uuid not null,
  clicked_at timestamptz not null default now()
);
create index if not exists product_clicks_product_time_idx on public.product_clicks(product_id, clicked_at desc);
create index if not exists product_clicks_visitor_idx on public.product_clicks(visitor_id);
alter table public.product_clicks enable row level security;
drop policy if exists "Public can record product clicks" on public.product_clicks;
create policy "Public can record product clicks" on public.product_clicks
  for insert to anon, authenticated with check (
    exists (select 1 from public.products p where p.id = product_id)
  );
drop policy if exists "Admin can read product clicks" on public.product_clicks;
create policy "Admin can read product clicks" on public.product_clicks
  for select to authenticated using (lower(coalesce(auth.jwt() ->> 'email','')) = 'vv0303747@gmail.com');

create table if not exists public.product_reviews (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 2 and 40),
  rating integer not null check (rating between 1 and 5),
  comment text not null check (char_length(comment) between 5 and 500),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);
create index if not exists product_reviews_product_status_idx on public.product_reviews(product_id, status, created_at desc);
alter table public.product_reviews enable row level security;
drop policy if exists "Public can read approved reviews" on public.product_reviews;
create policy "Public can read approved reviews" on public.product_reviews
  for select to anon, authenticated using (status = 'approved');
drop policy if exists "Public can submit pending reviews" on public.product_reviews;
create policy "Public can submit pending reviews" on public.product_reviews
  for insert to anon, authenticated with check (
    status = 'pending'
    and exists (select 1 from public.products p where p.id = product_id)
  );
drop policy if exists "Admin can read all reviews" on public.product_reviews;
create policy "Admin can read all reviews" on public.product_reviews
  for select to authenticated using (lower(coalesce(auth.jwt() ->> 'email','')) = 'vv0303747@gmail.com');
drop policy if exists "Admin can moderate reviews" on public.product_reviews;
create policy "Admin can moderate reviews" on public.product_reviews
  for update to authenticated
  using (lower(coalesce(auth.jwt() ->> 'email','')) = 'vv0303747@gmail.com')
  with check (lower(coalesce(auth.jwt() ->> 'email','')) = 'vv0303747@gmail.com');

-- Public website can read only aggregated counts (not raw visitor IDs/events).
create or replace function public.get_public_product_click_counts()
returns table(product_id uuid, click_count bigint)
language sql
security definer
set search_path = public
as $$
  select pc.product_id, count(*)::bigint
  from public.product_clicks pc
  group by pc.product_id;
$$;
revoke all on function public.get_public_product_click_counts() from public;
grant execute on function public.get_public_product_click_counts() to anon, authenticated;

-- Admin-only aggregate report. Raw visitor IDs stay private in the table.
create or replace function public.get_admin_product_analytics()
returns table(
  product_id uuid,
  product_name text,
  click_count bigint,
  unique_visitors bigint,
  clicks_last_7_days bigint
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if lower(coalesce(auth.jwt() ->> 'email','')) <> 'vv0303747@gmail.com' then
    raise exception 'Not authorized';
  end if;
  return query
    select p.id, p.name, count(pc.id)::bigint,
      (select count(distinct visitor_id)::bigint from public.product_clicks),
      (count(pc.id) filter (where pc.clicked_at >= now() - interval '7 days'))::bigint
    from public.products p
    left join public.product_clicks pc on pc.product_id = p.id
    group by p.id, p.name
    order by count(pc.id) desc, p.name asc;
end;
$$;
revoke all on function public.get_admin_product_analytics() from public;
grant execute on function public.get_admin_product_analytics() to authenticated;

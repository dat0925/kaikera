-- =====================================================
-- Kaikera DB スキーマ
-- =====================================================

-- アカウント（Suica, PayPay, 現金など）
create table if not exists kk_accounts (
  id           text        primary key,
  user_id      uuid        not null references auth.users(id) on delete cascade,
  name         text        not null,
  type         text        not null default 'cash',
  balance      numeric     not null default 0,
  color        text        not null default '#eef2ff',
  sort_order   int         not null default 0,
  created_at   timestamptz not null default now()
);

create index if not exists kk_accounts_user_id_idx on kk_accounts (user_id);
alter table kk_accounts enable row level security;
create policy "kk_accounts: own" on kk_accounts for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- カテゴリ
create table if not exists kk_categories (
  id           text        primary key,
  user_id      uuid        not null references auth.users(id) on delete cascade,
  name         text        not null,
  icon         text        not null default '📦',
  color        text        not null default '#6b7280',
  type         text        not null default 'expense',
  sort_order   int         not null default 0,
  created_at   timestamptz not null default now()
);

create index if not exists kk_categories_user_id_idx on kk_categories (user_id);
alter table kk_categories enable row level security;
create policy "kk_categories: own" on kk_categories for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- 取引
create table if not exists kk_transactions (
  id              text        primary key,
  user_id         uuid        not null references auth.users(id) on delete cascade,
  type            text        not null default 'expense', -- income / expense / transfer
  amount          numeric     not null default 0,
  category_id     text,
  account_id      text        not null,
  to_account_id   text,                                   -- 振替先（transferのみ）
  memo            text        not null default '',
  date            date        not null default current_date,
  created_at      timestamptz not null default now()
);

create index if not exists kk_transactions_user_id_idx on kk_transactions (user_id);
create index if not exists kk_transactions_date_idx on kk_transactions (user_id, date desc);
alter table kk_transactions enable row level security;
create policy "kk_transactions: own" on kk_transactions for all using (user_id = auth.uid()) with check (user_id = auth.uid());

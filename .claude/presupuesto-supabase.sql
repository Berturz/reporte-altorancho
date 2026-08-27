-- ═══════════════════════════════════════════════════════════════
--  Control presupuestario 2026 — tabla y permisos en Supabase
--  Pegar en: Supabase → SQL Editor → New query → Run
--  (se puede volver a correr sin romper nada)
-- ═══════════════════════════════════════════════════════════════

-- 1) Tabla propia, separada de la del reporte comercial
create table if not exists public.presupuesto_data (
  id          text primary key,
  data        jsonb,
  updated_at  timestamptz default now(),
  updated_by  text
);

alter table public.presupuesto_data enable row level security;

-- 2) Lista de mails habilitados  ← EDITAR ACÁ para sumar/quitar gente
create or replace function public.presupuesto_ok() returns boolean
language sql stable as $$
  select coalesce(auth.jwt() ->> 'email', '') in (
    'MAIL_HABILITADO@altorancho.com'   -- << reemplazar por los mails reales antes de correr
    -- , 'otro@altorancho.com'
  );
$$;

-- 3) Un solo permiso: leer y escribir solo si el mail está en la lista
drop policy if exists presupuesto_acceso on public.presupuesto_data;
create policy presupuesto_acceso on public.presupuesto_data
  for all to authenticated
  using (public.presupuesto_ok())
  with check (public.presupuesto_ok());

-- 4) Fila inicial (la página guarda con PATCH, necesita que exista)
insert into public.presupuesto_data (id, data)
values ('main', '{}'::jsonb)
on conflict (id) do nothing;

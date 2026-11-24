-- BinRun manual customer messages + private photo proof.
-- Additive migration. Does not alter the existing owner workspace, sync RPC, or customer data.
-- If the earlier v13 SMS/photo migration already ran successfully, this bucket and its policies
-- are already present; running this file again is safe but unnecessary.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'binrun-service-proof',
  'binrun-service-proof',
  false,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = false,
  file_size_limit = 5242880,
  allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp'];

drop policy if exists "BinRun owner upload own service proof" on storage.objects;
create policy "BinRun owner upload own service proof"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'binrun-service-proof'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

drop policy if exists "BinRun owner view own service proof" on storage.objects;
create policy "BinRun owner view own service proof"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'binrun-service-proof'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

drop policy if exists "BinRun owner update own service proof" on storage.objects;
create policy "BinRun owner update own service proof"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'binrun-service-proof'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  )
  with check (
    bucket_id = 'binrun-service-proof'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

drop policy if exists "BinRun owner delete own service proof" on storage.objects;
create policy "BinRun owner delete own service proof"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'binrun-service-proof'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

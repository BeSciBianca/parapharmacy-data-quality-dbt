-- test that the intended grain is respected: one stock lot per snapshot date.

{{config(severity='warn')}}


select 
    snapshot_date, 
    lot_id,
    count(*) as id_count
from {{ ref('stg_inventory__inventory_snapshots') }}
group by 
    snapshot_date, 
    lot_id
having (count(*) > 1)

with flags as (
select 
    snapshot_date, lot_id, flag  
from {{ ref('int_quality__date_type_flagged') }}
union all 
    select snapshot_date, lot_id, flag 
        from {{ ref('int_quality__price_flagged') }}
union all 
    select snapshot_date, lot_id, flag 
        from {{ ref('int_quality__quantity_flagged') }}
)

select 
    f.snapshot_date, 
    f.lot_id, 
    flag, 
    s.outlet_id, 
    s.family_code
from flags f
    left join {{ ref('stg_inventory__inventory_snapshots') }} s
    using(snapshot_date, lot_id)
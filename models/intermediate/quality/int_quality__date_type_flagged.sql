/* Cold-chain items (C) don't have EXP (both in type and a date), 
   or ambient items (A) don't have their family's expected_date_type, 
   or the date type is missing 
   
   Exclude Quarantine (Q) from scope */

with joined as (
select * from {{ ref('stg_inventory__inventory_snapshots') }} stg
    left join {{ ref('product_families') }} seed
        on stg.family_code = seed.family_cd
),

cold_chain_flag as (
    select 
        snapshot_date, 
        lot_id,
        date_type as actual_date_type,
        'EXP' as expected_date_type, 
        'cold_chain_flag' as flag
    from joined   
    where storage_zone = 'C' and 
        (date_type <> 'EXP' or (date_type = 'EXP' and expiry_date is null))
), 

ambient_flag as (
    select 
        snapshot_date, 
        lot_id,
        date_type as actual_date_type,
        expected_date_type, 
        'ambient_flag' as flag
    from joined
    where storage_zone = 'A' and date_type <> expected_date_type
), 

missing_date_type_flag as (
    select 
        snapshot_date, 
        lot_id,
        date_type as actual_date_type,
        expected_date_type, 
        'missing_date_type_flag' as flag
    from joined
    where storage_zone <> 'Q' and date_type is null 
)

select 
    snapshot_date, lot_id, flag
from cold_chain_flag 
    union all select snapshot_date, lot_id, flag
        from ambient_flag 
    union all select snapshot_date, lot_id, flag
        from missing_date_type_flag
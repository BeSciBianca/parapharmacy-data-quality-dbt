/* listed_exceeds_received` 
        `qty_listed > qty_recv`
        All rows
*/

with listed_exceeds_received as (
    select 
        snapshot_date, 
        lot_id, 
        'listed_exceeds_received' as flag, 
        units_on_sale,
        units_received 
    from {{ ref('stg_inventory__inventory_snapshots') }}
    where units_on_sale > units_received
), 


/* `remaining_mismatch`
        `qty_remaining` ≠ `qty_listed − qty_sold`
        All rows
*/
remaining_mismatch as (
select  
    snapshot_date, 
    lot_id, 
    'remaining_mismatch' as flag, 
    units_remaining, 
    units_on_sale - units_sold
from {{ ref('stg_inventory__inventory_snapshots') }}
where units_remaining <> units_on_sale - units_sold
)

select
    snapshot_date, 
    lot_id, 
    flag
from listed_exceeds_received
union all select 
        snapshot_date, 
        lot_id, 
        flag
    from remaining_mismatch

-- there are some negative 'units remaining' to check 

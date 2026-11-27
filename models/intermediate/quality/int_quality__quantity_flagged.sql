/* listed_exceeds_received` 
        `qty_listed > qty_recv`
        All rows
*/

select 
    snapshot_date, 
    lot_id, 
    'listed_exceeds_received' as flag
from {{ ref('stg_inventory__inventory_snapshots') }}
where units_on_sale > units_received
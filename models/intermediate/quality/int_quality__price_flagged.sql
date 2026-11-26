/* discount_mismatch	
    prc_sale ≠ prc_list × (1 − disc_rate)	
    Only where disc_rate > 0 */

with discount_mismatch as (
    select 
        snapshot_date, 
        lot_id, 
        'discount_mismatch' as flag, 
        price_sale,
        round(price_before_discount * (1-discount_rate), 2) as expected_price_sale
    from {{ ref('stg_inventory__inventory_snapshots') }}
    where 
        discount_rate > 0 and 
        price_sale not between round(price_before_discount * (1-discount_rate), 2) - 0.01 and 
            round(price_before_discount * (1-discount_rate), 2) + 0.01

-- reminder: consider rates bigger than 1, negative price of sale 
), 

/*
ppu_mismatch	
    ppu_100 ≠ prc_sale / pack_size × 100	
    Only products sold by g or ml
*/

ppu_mismatch as (
    select 
        snapshot_date, 
        lot_id, 
        'ppu_mismatch' as flag, 
        price_per_100, 
        price_sale,
        pack_size
    from {{ ref('stg_inventory__inventory_snapshots') }}
    where pack_unit in('ml', 'g') and 
        price_per_100 not between round(price_sale / nullif(pack_size,0) * 100, 2) - 0.01 and 
            round(price_sale / nullif(pack_size,0) * 100, 2) + 0.01
)

/*
-- there seems to be a big mistake in how the price per 100 units is measured, with this value often being 10 times what it is supposed to be 
select 
(select count(*) 
from ppu_mismatch) as flagged_ppu_mismatch, 
(select count(*)
from {{ ref('stg_inventory__inventory_snapshots') }}) as total_rows
*/


select snapshot_date, lot_id, flag 
from discount_mismatch
    union all select snapshot_date, lot_id, flag
        from ppu_mismatch


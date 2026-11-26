/* discount_mismatch	
    prc_sale ≠ prc_list × (1 − disc_rate)	
    Only where disc_rate > 0 */

with discount_mismatch as (
    select 
        snapshot_date, 
        lot_id, 
        'discount_mismatch' as flag, 
        price_sale,
        round(price_before_discount * (1-discount_rate), 2)
    from {{ ref('stg_inventory__inventory_snapshots') }}
    where 
        discount_rate > 0 and 
        price_sale not between round(price_before_discount * (1-discount_rate), 2) - 0.01 and 
            round(price_before_discount * (1-discount_rate), 2) + 0.01

-- reminder: consider negative rates, negative price of sale 
)


select * 
from
    discount_mismatch

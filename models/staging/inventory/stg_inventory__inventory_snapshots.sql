with source as (


    select * from {{ source('inventory', 'inventory_snapshots') }}

),

renamed as (

    select

        snapshot_dt as snapshot_date,
        branch_hash as outlet_id,
        lot_id,
        product_id,
        product_name,
        family_cd as family_code,
        storage_zone,
        date_type,
        expiry_dt as expiry_date,
        prc_list as price_before_discount,
        disc_rate as discount_rate,
        prc_sale as price_sale,
        pack_size,
        pack_unit,
        ppu_100 as price_per_100,
        qty_recv as units_received,
        qty_listed as units_on_sale,
        qty_sold as units_sold,
        qty_remaining as units_remaining
        
    from source

)

select * from renamed
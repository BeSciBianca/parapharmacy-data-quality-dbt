with source as (


    select * from {{ source('inventory', 'inventory_snapshots') }}

),

deduplicated as (
    select distinct * from source
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
        
    from deduplicated

), 

cleaned as (

    select 

        try_cast(snapshot_date as date) as snapshot_date,
        outlet_id,
        lot_id,
        product_id,
        trim(product_name) as product_name,
        upper(trim(family_code)) as family_code,
        upper(trim(storage_zone)) as storage_zone,
        upper(trim(date_type)) as date_type,
        try_cast(expiry_date as date) as expiry_date,
        try_cast(price_before_discount as number(10,2)) as price_before_discount,
        try_cast(discount_rate as number(10, 2)) as discount_rate,
        try_cast(price_sale as number(10, 2)) as price_sale,
        try_cast(pack_size as integer) as pack_size,
        /* Necessary transformations for pack_unit: 
            - All lowercase letters
            - gr into g CASE WHEN 
            - pc  and pcs into unit CASE WHEN */
        case when lower(trim(pack_unit)) = 'gr' then 'g' 
            when lower(trim(pack_unit)) in ('pc', 'pcs') then 'unit'
            when pack_unit is null then 'unit'
            else lower(trim(pack_unit)) end as pack_unit,
        try_cast(price_per_100 as number(10, 2)) as price_per_100,
        try_cast(units_received as integer) as units_received,
        try_cast(units_on_sale as integer) as units_on_sale,
        try_cast(units_sold as integer) as units_sold,
        try_cast(units_remaining as integer) as units_remaining
        
    from renamed
)

select * from cleaned

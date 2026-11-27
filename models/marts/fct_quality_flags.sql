select 
    snapshot_date, lot_id, flag  
from {{ ref('int_quality__date_type_flagged') }}
union all 
    select snapshot_date, lot_id, flag 
        from {{ ref('int_quality__price_flagged') }}
union all 
    select snapshot_date, lot_id, flag 
        from {{ ref('int_quality__quantity_flagged') }}
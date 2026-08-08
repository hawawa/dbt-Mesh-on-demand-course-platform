with
success_payment_by_order as
(
    select
        order_id,
        sum(amount) as amount,
    from {{ ref('stg_stripe__payments') }}
    where status = 'success'
    group by order_id
)


select
    p.order_id,
    o.customer_id,
    coalesce(p.amount, 0) as amount
from success_payment_by_order as p
    left join {{ ref('stg_jaffle_shop__orders') }} as o
        on p.order_id = o.order_id
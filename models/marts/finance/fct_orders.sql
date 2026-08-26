with customers as (

select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

select * from {{ ref('stg_stripe__payments') }}

),

order_payments as (

select
    orders.order_id,
    sum(case when payment_status = 'success' then payment_amount else 0 end) as payment_amount       

  from orders

left join payments using (order_id)

group by 1

),


final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        order_payments.payment_amount

    from orders

    left join order_payments using (order_id) 
)

select * from final
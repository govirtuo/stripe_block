view: charges {
  sql_table_name: stripe.charges ;;

  ## Dimensions

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount*1.0/100 ;;
    value_format: "\"€\"#0.00"
  }

  dimension: amount_refunded {
    type: number
    sql: ${TABLE}.amount_refunded*1.0/100 ;;
    value_format: "\"€\"#0.00"
  }

  dimension: captured {
    type: yesno
    sql: ${TABLE}.captured ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: customer_id {
    type: string
    # hidden: true
    sql: ${TABLE}.customer_id ;;
  }

  dimension: dispute_id {
    type: string
    sql: ${TABLE}.dispute_id ;;
  }

  dimension: failure_code {
    type: string
    sql: ${TABLE}.failure_code ;;
  }

  dimension: paid {
    type: yesno
    sql: ${TABLE}.paid ;;
  }

  dimension: refunded {
    type: yesno
    sql: ${TABLE}.refunded ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  ## Measures

  measure: total_gross_amount {
    type: sum
    sql: ${amount} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
    drill_fields: [detail*]
  }

  measure: total_failed_charges {
    type: sum
    sql: ${amount} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
    drill_fields: [detail*]

    filters: {
      field: status
      value: "failed"
    }
  }

  measure: total_refunds {
    type: sum
    sql: ${amount_refunded} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
    drill_fields: [detail*]
  }

  measure: total_net_amount {
    type: number
    sql: ${total_gross_amount} - ${total_refunds} - ${total_failed_charges} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
    drill_fields: [detail*]
  }

  measure: cumulative_gross {
    type: running_total
    sql: ${total_gross_amount} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
  }

  measure: cumulative_refunds {
    type: running_total
    sql: ${total_refunds} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
  }

  measure: cumulative_net {
    type: running_total
    sql: ${total_net_amount} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
  }

  measure: avg_charge_amount {
    type: average
    sql: ${amount} ;;
    value_format: "[>=1000000]\"€\"#0.00,,\"M\";[>=1000]\"€\"#0.00,\"K\";\"€\"#0.00"
  }

  measure: charge_count {
    type: count
    drill_fields: [detail*]
  }

  measure: refund_count {
    type: count
    drill_fields: [id, customers.id]

    filters: {
      field: refunded
      value: "Yes"
    }
  }

  # ----- Sets of fields for drilling -----

  set: detail {
    fields: [
      id,
      captured,
      amount,
      amount_refunded,
      currency,
      paid,
      failure_code,
      created_time,
      customers.email
    ]
  }
}

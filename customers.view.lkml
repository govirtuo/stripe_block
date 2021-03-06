view: customers {
  sql_table_name: stripe.customers ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
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

  dimension: delinquent {
    type: yesno
    sql: ${TABLE}.delinquent ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    html: <a href="/dashboards/segment_stripe::customer_lookup?customer_email={{ value }}">{{ value }}</a>
      ;;
  }

  dimension: metadata_user_id {
    type: string
    sql: ${TABLE}.metadata_user_id ;;
    html: <a href="https://virtuo-back-office-prod.herokuapp.com/user/{{ value }}">{{ value }}</a>
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------

  set: detail {
    fields: [
      id,
      customers.email,
      customers.created_date,
      charges.count
    ]
  }
}

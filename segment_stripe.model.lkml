connection: "production"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: calendar {
  label: "Charges"

  join: charges {
    type: left_outer
    relationship: one_to_many
    sql_on: ${calendar.cal_date_date} = ${charges.created_date};;
  }

  join: customers {
    type: left_outer
    sql_on: ${charges.customer_id} = ${customers.id} ;;
    relationship: many_to_one
  }
}

explore: customer {
  from: calendar
  label: "Customers"

  join: customers {
    type: left_outer
    sql_on: ${customer.cal_date_date} = ${customers.created_date} ;;
    relationship: one_to_many
  }
}

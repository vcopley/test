# -------------------------------------------------------
# User defined functions
# -------------------------------------------------------

# Standardise the distance or duration units
unit_standard <- function (a, b, c) {
  if (b=="2" | b=="3") {
    x <- 1
  }else if (b=="1") {
    x <-60            # minutes per hour
  } else if (b=="4") {
    x <- 0.621371192  # Kilometres per mile
  } else {
    x <- 1000         # metres per kilometre
  }
  a / x * c
}
  

# Protective benefit from duration
benefit_duration <- function (ref_rr, duration, ref_du, ref_weeks) {
  ben <- (1 - ref_rr) * ( duration / (ref_du / 60 * ref_weeks) )
  min(0.45, ben)
}

# Protective benefit from distance
benefit_distance <- function (ref_rr, distance, ref_du, ref_weeks, ref_speed) {
  ben <- (1 - ref_rr) * ( distance / ((ref_du / 60 * ref_weeks) * ref_speed))
  min(0.45, ben)
}

# Protective benefit from trips not yet implemented


# Update the data frame
update_data <- function (results, benefit, mortality_df, localpop, mortality_age, 
                         mortality_area, vsl_area, vsl_df, user_vsl, disc_rate) {
  # Best practice to convert mortality rate to probability - not yet done
  mort_ppy <- mortality_df[match(mortality_area, mortality_df[,1]), mortality_age]/100000
  vsl <- if(user_vsl>0) user_vsl else vsl_df[match(vsl_area, vsl_df[,1]), 3]
  results$protective_benefit <- results$propnew * benefit
  results$started_cycling <- localpop
  results$lives_saved <- results$protective_benefit * mort_ppy * localpop
  results$money_saved <- results$lives_saved * vsl
  results$money_saved_discounted <- results$money_saved/(1+disc_rate)^results$year
  # return the whole data frame
  results
}





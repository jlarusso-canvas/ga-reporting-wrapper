load 'service_account.rb'

sa = ServiceAccount.new

class Exit
  extend Legato::Model

  metrics :exits, :pageviews
  # dimensions :page_path, :operating_system, :browser
  # dimensions :page_path

  # Filters -------------------------------------------------------------------
  filter :high_exits, &lambda {gte(:exits, 30)}
  filter :low_pageviews, &lambda {lte(:pageviews, 40)}
end

# Returns a Legato::Query
# sa.profile.exit

# Any enumerable kicks off the request to GA
# sa.profile.exit.each {}

# Filters
# Exit.high_exits(sa.profile).each {}
# Exit.low_pageviews(sa.profile).each {}
#
# Filter chainging
# Exit.high_exits.low_pageviews(sa.profile).each {}

# Time stuff
# sa.profile.exit.results(start_date: Time.now - 2.days).each {}.count


# TODO: offsets for > 1000 results

binding.pry

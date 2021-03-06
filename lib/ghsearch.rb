require 'http'
require 'time'
require 'rainbow/refinement'
require 'action_view'

require_relative 'github'

class Searcher
  SEARCH_ENDPOINT = "https://api.github.com/search/repositories"
  MAX_RESULTS = 3

  def self.search(q)
    params = { q: q, per_page: MAX_RESULTS }
    res = HTTP.get(SEARCH_ENDPOINT, params: params).parse
    res = Github::SearchRepositoriesResponse.from_json_data(res)

    res.items.map do |item|
      search_result = SearchResult.new
        search_result.url = item.html_url
        search_result.name = item.full_name
        search_result.description = item.description
        search_result.stars = item.stargazers_count
        search_result.issues = item.open_issues
        search_result.created_at = item.created_at
        search_result.updated_at = item.updated_at
        search_result.license = item.license&.name

        search_result
    end
  end
end

class SearchResult
  using Rainbow
  include ActionView::Helpers::DateHelper

  attr_accessor :url
  attr_accessor :name
  attr_accessor :description
  attr_accessor :stars
  attr_accessor :issues
  attr_accessor :created_at
  attr_accessor :updated_at
  attr_accessor :license

  def to_pretty_s
    <<~PRETTY
      #{name.bright} ⭐ #{stars.to_s.yellow} 🐛 #{issues.to_s.cyan} ⚖️  #{license || "Unknown".red}
      Updated #{ago(updated_at)}, created #{ago(created_at)}
      #{description}
      #{url}
    PRETTY
  end

  private

  def ago(date_time)
    "#{distance_of_time_in_words_to_now(date_time)} ago"
  end
end

# We gate the actual running of this code behind a check to see if we're the
# "main", so that typeprof and other programs can introspect our code without
# actually "running" it.
if __FILE__ == $0
  results = Searcher.search(ARGV[1])
  results.each_with_index do |result, index|
    puts result.to_pretty_s

    # Put a blank line between each result
    puts unless index == results.size - 1
  end
end

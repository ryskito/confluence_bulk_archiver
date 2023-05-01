require 'net/http'
require 'json'

def get_children_page_ids
  uri = URI.parse(
    File.join(ARGV[0], "wiki/rest/api/content/#{ARGV[1]}/child/page")
  )
  req = Net::HTTP::Get.new(uri)
  req.basic_auth(ENV.fetch('CONFLUENCE_USER_NAME'), ENV.fetch('CONFLUENCE_API_TOKEN'))
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    http.request(req)
  end

  if res.is_a?(Net::HTTPSuccess)
    JSON
      .parse(res.body, symbolize_names: true)
      .fetch(:results)
      .map { |hash| hash.fetch(:id) }
  else
    raise res.body
  end
end

def bulk_archive(page_ids)
  if page_ids.empty?
    puts 'finished!'
    exit
  end

  page_ids.each do |page_id|
    uri = URI.parse(
      File.join(ARGV[0], "wiki/rest/api/content/archive")
    )
    req = Net::HTTP::Post.new(uri)
    req.basic_auth(ENV.fetch('CONFLUENCE_USER_NAME'), ENV.fetch('CONFLUENCE_API_TOKEN'))
    req.content_type = 'application/json'
    req.body = { pages: [{ id: page_id }] }.to_json
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    if res.is_a?(Net::HTTPSuccess)
      puts res.body
    else
      raise res.body
    end
  end
end

loop do
  bulk_archive(
    get_children_page_ids
  )
end

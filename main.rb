# frozen_string_literal: true

require 'bundler'
Bundler.require(:default)

require_relative './lib/converter'

require 'net/http'
require 'oj'

Oj.mimic_JSON

def aggregate(aggregate_api, body)
  uri = URI(aggregate_api)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    request = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
    request.body = body
    http.request request
  end
end

def handler(event:, context:) # rubocop:disable Lint/UnusedMethodArgument
  feed = Converter.load(event['feed'])
  res = aggregate(event['aggregate_api'], feed.to_json)
  return 'Success!' if res.is_a?(Net::HTTPOK)

  raise "Unable to convert to JSON: #{res.body}"
end

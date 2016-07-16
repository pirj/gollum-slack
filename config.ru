require_relative 'deepie.rb'
require 'json'
require 'uri'
require 'net/http'

WEBHOOK_PATH = "/#{ENV['WEBHOOK_PATH']}"

DEFAULT_TEMPLATE = '#{sender.login} has #{pages.first.action} page \'#{pages.first.title}\' at #{pages.first.html_url}'
template = ENV['TEMPLATE'] || DEFAULT_TEMPLATE
QUOTED_TEMPLATE = "\"#{template}\""

SLACK_URI = URI ENV['SLACK_URI']

app = Proc.new do |env|
  request = Rack::Request.new env

  fail "wrong path #{request.path}" unless request.path == WEBHOOK_PATH

  json = Mash.new JSON.parse request.body.read

  text = json.instance_eval QUOTED_TEMPLATE
  data = {text: text}.to_json

  https = Net::HTTP.new SLACK_URI.host, SLACK_URI.port
  https.use_ssl = true
  https.post2 SLACK_URI.path, data, {'Content-Type' =>'application/json'}

  [200, {'Content-Type'=>'text/plain'}, StringIO.new('')]
end

run app

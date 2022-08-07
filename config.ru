require 'rack/parser'
require './application'

use Rack::Reloader, 0
use Rack::Parser, :parsers => { 'application/json' => proc { |data| JSON.parse data } }
use Rack::Parser, :handlers => {
  'application/json' => proc { |e, type| [400, { 'Content-Type' => type }, ['broke']] }
}
run Application.new

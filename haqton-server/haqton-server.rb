require 'ffi-rzmq'
require 'jwt'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/cors'

$context = ZMQ::Context.new
$publisher = $context.socket(ZMQ::PUB)
$publisher.connect("tcp://127.0.0.1:5559")

class Log < ActiveRecord::Base
end

class JwtAuth
  def initialize app
    @app = app
  end

  def call env
    begin
      public_key = OpenSSL::PKey::RSA.new(File.read ENV['PUBLIC_KEY_FILE'])

      options = { algorithm: 'RS256', iss: ENV['JWT_ISSUER'] }
      token = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
      payload, header = JWT.decode token, public_key, true, options

      env[:token_username] = payload['user']['username']
      Log.create(user: env[:token_username], endpoint: env['REQUEST_METHOD'] + ' ' + env['PATH_INFO'], datetime: DateTime.now)

      @app.call env
    rescue JWT::DecodeError
      [401, { 'Content-Type' => 'text/plain' }, ['{ "error": "A valid token must be passed." }']]
    rescue JWT::ExpiredSignature
      [403, { 'Content-Type' => 'text/plain' }, ['{ "error": "The token has expired." }']]
    rescue JWT::InvalidIssuerError
      [403, { 'Content-Type' => 'text/plain' }, ['{ "error": "The token does not have a valid issuer." }']]
    rescue JWT::InvalidIatError
      [403, { 'Content-Type' => 'text/plain' }, ['{ "error": "The token does not have a valid "issued at" time." }']]
    end
  end
end

class HaqtonServerPrivate < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Cors

#  use JwtAuth

  set :allow_origin, "*"
  set :allow_methods, "GET,POST,PUT,DELETE"
  set :allow_headers, "content-type,if-modified-since"
  set :expose_headers, "location,link"
end

current_dir = Dir.pwd
Dir["#{current_dir}/plugins/*.rb"].each { |file| require file }

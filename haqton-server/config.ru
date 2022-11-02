require "./haqton-server"

run Rack::URLMap.new({
  '/' => HaqtonServerPrivate
})

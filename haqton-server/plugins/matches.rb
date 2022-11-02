class Match < ActiveRecord::Base
  has_many :match_players, :dependent => :destroy
  has_and_belongs_to_many :questions, join_table: "matches_questions", :dependent => :destroy
end

class MatchPlayer < ActiveRecord::Base
  belongs_to :match
end

class HaqtonServerPrivate < Sinatra::Base
  get '/matches' do
    Match.where(status: 0).order(:id).to_json(:include => [ :match_players ])
  end

  post '/matches' do
    payload = JSON.parse(request.body.read)
    match = Match.new
    match.description = payload['description']
    match.creator_name = payload['nickname']
    match.creator_email = payload['email']
    match.status = 0
    topic = -1
    loop do
      topic = rand(1..50000)
      break if !Match.find_by({ topic: topic, status: 0..1 })
    end
    match.topic = topic
    match.match_players << MatchPlayer.create(player_name: payload['nickname'], player_email: payload['email'], approved: true, score: 0)
    match.save
    $publisher.send_string('matches', ZMQ::SNDMORE)
    $publisher.send_string('{ "message": "matches_update", "data": ' + Match.where(status: 0).order(:id).to_json(:include => [ :match_players ]) + ' }')
    match.to_json(:include => [ :match_players ])
  end

  put '/matches/:id' do
    match = Match.find_by(id: params[:id])
    if match
      payload = JSON.parse(request.body.read)
      statusBefore = match.status
      match.status = payload['status']
      match.save
      $publisher.send_string('matches', ZMQ::SNDMORE)
      $publisher.send_string('{ "message": "matches_update", "data": ' + Match.where(status: 0).order(:id).to_json(:include => [ :match_players ]) + ' }')
      if statusBefore == 1 and match.status == 2
        $publisher.send_string(match.topic.to_s, ZMQ::SNDMORE)
        $publisher.send_string('{ "message": "match_finished" }')
      end
      match.to_json(:include => [ :match_players ])
    else
      status 403
      '{ "error": "Match not found" }'
    end
  end

  delete '/matches/:id' do
    match = Match.find_by(id: params[:id])
    if match
      match.destroy
      $publisher.send_string('matches', ZMQ::SNDMORE)
      $publisher.send_string('{ "message": "matches_update", "data": ' + Match.where(status: 0).order(:id).to_json(:include => [ :match_players ]) + ' }')
      '{ "message": "Match successfully deleted" }'
    else
      status 403
      '{ "error": "Match not found" }'
    end
  end

  post '/matches/:id/players' do
    match = Match.find_by(id: params[:id])
    if match
      payload = JSON.parse(request.body.read)
      match.match_players << MatchPlayer.create(player_name: payload['nickname'], player_email: payload['email'], approved: false, score: 0)
      match.save
      $publisher.send_string(match.topic.to_s, ZMQ::SNDMORE)
      $publisher.send_string('{ "message": "players_update", "data": ' + match.match_players.to_json + ' }')
      match.match_players.to_json
    else
      status 403
      '{ "error": "Match not found" }'
    end
  end

  put '/matches/:mid/players/:pid' do
    match = Match.find_by(id: params[:mid])
    if !match
      status 403
      return '{ "error": "Match not found" }'
    end
    player = match.match_players.find_by(id: params[:pid])
    if !player
      status 403
      return '{ "error": "Player not found in this match" }'
    end
    payload = JSON.parse(request.body.read)
    player.score = payload['score'] if payload['score']
    if payload['approved'] != nil
      if payload['approved'] == true
        player.approved = true
        player.save
      else
        player.destroy
      end
    end
    $publisher.send_string(match.topic.to_s, ZMQ::SNDMORE)
    $publisher.send_string('{ "message": "players_update", "data": ' + match.match_players.to_json + ' }')
    match.match_players.to_json
  end
end

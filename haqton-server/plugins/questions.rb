class Question < ActiveRecord::Base
  has_many :question_options, :dependent => :destroy
  has_and_belongs_to_many :matches, join_table: "matches_questions", :dependent => :destroy
end

class QuestionOption < ActiveRecord::Base
  belongs_to :question
end

class HaqtonServerPrivate < Sinatra::Base
  get '/matches/:id/random_question' do
    match = Match.find_by(id: params[:id])
    if !match
      status 403
      return '{ "error": "Match not found" }'
    end
    if match.status != 1
      status 403
      return '{ "error": "Match status must be running (1) to ask for questions" }'
    end
    if match.questions.count == Question.all.count
      status 404
      match.status = 2
      match.save
      $publisher.send_string(match.topic.to_s, ZMQ::SNDMORE)
      $publisher.send_string('{ "message": "match_finished" }')
      return '{ "error": "No more available questions for this match" }'
    end
    id = -1
    loop do
      id = rand(1..Question.count)
      break if !match.questions.find_by(id: id)
    end
    question = Question.find_by(id: id)
    match.questions << question
    $publisher.send_string(match.topic.to_s, ZMQ::SNDMORE)
    $publisher.send_string('{ "message": "new_question", "data": ' + question.to_json(:include => [ :question_options ]) + ' }')
    question.to_json(:include => [ :question_options ])
  end

  post '/matches/:mid/players/:pid/answer' do
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
    question = Question.find_by(id: payload['question_id'])
    if question.right_option == payload['player_option']
      player.score = player.score+1
      player.save
    end
    $publisher.send_string(match.topic.to_s, ZMQ::SNDMORE)
    $publisher.send_string('{ "message": "new_answer", "data": { "player_id": ' + params[:pid] + ', "player_option": ' + payload['player_option'].to_s + ' } }')
    payload.to_json
  end
end

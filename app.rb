require 'sinatra'
require "sinatra/reloader"

get '/' do
  'Hello world! welcome'
end


get '/htmlfile' do
    send_file "views/htmlfile.html"
end


get '/htmltag' do
    '<h1>html태그를 보낼 수 있습니다.</h1>
    <ol>
    <li>1</li>
    <li>2</li>
    </ol>
    '
end


get '/welcome/:name' do
    "#{params[:name]}님 안녕하세요"
end

get '/cube/:num' do
    "result = #{params[:num].to_i ** 3}"
end

get '/erbfile' do
    @name = "ranyoung2"
    erb :erbfile
end

get '/dinner-array' do
    # 메뉴들을 배열에 저장한다
    # 하나를 추천한다
    # erb 파일에 담아서 렌더링한다
    menu = ["치킨", "피자", "닭발", "찜닭", "삼겹살"]
    @dinner = menu.sample
    erb :dinnerarray
end


get '/dinner-hash' do
    # 메뉴들이 저장된 배열을 만든다
    # key : 이름 value : URL 을 가진 hash를 만든다
    # 랜덤으로 하나를 출력한다
    # 이름과 url을 넘겨서 erb를 렌더링 한다.
    
    menu =  ["치킨", "피자", "닭발"]
    
    menu_img = {
    "치킨" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcXoy26bucgoboQNUXVZbqnvz8jaqR3pUzDbmOMNacB0f3V5qk",
    "피자" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-n6MNDDz_RMy5t3vQGE6QSLuHuHvXOiZe_HCdfSUdXOCLiGrWfA",
    "닭발" => "http://file3.instiz.net/data/file3/2018/03/09/8/3/d/83d904079dd593a925a5806c1d258355.gif"
    }
    
    sel = menu.sample
    @dinner = sel
    @dinner_img = menu_img[sel]
    
    erb :dinnerhash
end
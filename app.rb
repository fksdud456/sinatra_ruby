require 'sinatra'
require 'sinatra/reloader'
require 'rest-client'
require 'json'
require 'httparty'
require 'nokogiri'
require 'uri'
require 'date'
require 'csv'

# 아래 method를 실행하기 전에 먼저 실행해라
before do
    p "***********************************"
    p params
    p request.path_info # 사용자가 요청보낸 경로
    p request.fullpath  # 파라미터까지 포함한 경로
    p "***********************************"
end

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

get '/randomgame/:name' do
    random = ["로또당첨", "잔병치레", "새 친구","다이어트 성공", "이직"]
    
    @name = params[:name]
    @random = random.sample
    erb :randomgame
end


get '/randomgame2/:name' do
 
    hash = {
        "사이온" => "http://opgg-static.akamaized.net/images/lol/champion/Sion.png?image=w_140&v=1",
        "우르곳" => "http://opgg-static.akamaized.net/images/lol/champion/Urgot.png?image=w_140&v=2",
        "타릭" => "http://opgg-static.akamaized.net/images/lol/champion/Taric.png?image=w_140&v=1",
        "탐켄치" => "http://opgg-static.akamaized.net/images/lol/champion/TahmKench.png?image=w_140&v=1",
        "문도" => "http://cfile6.uf.tistory.com/image/2662C63E52A1D2B7040B51"
    }
    
    @name = params[:name]
    @random = hash.keys.sample
    @url = hash[@random]
    erb :randomgame2
end

get '/lotto-sample' do
    #lotto = (1..45).class
    @lotto = (1..45).to_a.sample(6).sort
    url = "http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    @lotto_info = RestClient.get(url)
    @lotto_hash = JSON.parse(@lotto_info)
    
    @winner =[]
    @lotto_hash.each do |k,v|
        if k.include?("drwtNo")
            @winner << v 
        end
    end
    
    @num = (@winner & @lotto).length
    @bonusnum = @lotto_hash["bnusNo"]
    
    # if문 사용해서 등수 정하기
    if @num == 6 then @res = "1등"
    elsif @num== 5 && @lotto.include?(@bonusnum) then @res = "2등"
    elsif @num == 5 then @res = "3등"
    elsif @num == 4 then @res = "4등"
    elsif @num == 3 then @res = "5등"
    else @res = "6등"
    end
    
    # case문 사용해서 등수 정하기
    @result = case [@num, @lotto.include?(@bonusnum)]
    when [6, false] then "1등"
    when [5, true] then "2등"
    when [5, false] then "3등"
    when [4, false] then "4등"
    when [3, false] then "5등"
    else "꽝"
    end
    
    # 몇 등 인지??
    # @matchnum = 0
    # @lotto.each do |i|
    #     if winner.include?(i.to_s)
    #         @matchnum=@matchnum+1
    #     end
    # end

    erb :lottosample
end


get '/form' do
    erb :form
end

get '/search' do
    @keyword = params[:keyword]
    url = "https://search.naver.com/search.naver?query="
    # erb :search
    redirect to(url + @keyword)
end

get '/opgg' do
    erb :opgg
end

get '/opggresult' do
    # http://www.op.gg/summoner/userName=hideonbush
    url = "http://www.op.gg/summoner/userName="
    @userName = params[:userName]
    @encodeName = URI.encode(@userName)
    @res = HTTParty.get(url+@encodeName)
    
    # Nokogiri를 통해서 정제
    @doc = Nokogiri::HTML(@res.body)
    # body > div.l-wrap.l-wrap--summoner > div.l-container > div > div > div.Header > div.PastRank > ul > li.Item.tip.tpd-delegation-uid-1
    @rank7 = @doc.css("body > div.l-wrap.l-wrap--summoner > div.l-container > div > div > div.Header > div.PastRank > ul > li:nth-child(2)").text
    @rank = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierRank > span").text
    @win = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins").text
    @lose = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses").text
    
    # File.open(파일이름, 옵션) do |f|
    # end
    
    # File.open('opgg.txt', 'a+') do |f|
    #     f.write("#{@userName} : #{@win}, #{@lose}, #{@rank} , #{@rank7} \n")
    # end
    
    #csv파일에 작성하기 
    CSV.open('opgg.csv', 'a+') do |c|
        c << [@userName, @win, @lose, @rank, @rank7]
    end
    
    erb :opggresult
end


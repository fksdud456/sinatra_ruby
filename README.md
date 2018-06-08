# Sinatra study

### 0. version

- ruby : 2.4.0

### 1. sinatra

- `mkdir sinatra-test`
    - sinatra 파일들을 저장할 폴더 생성
- `cd sinatra-test`
    - 생성한 폴더로 이동
- `touch app.rb`
    - 루비 코드를 작성할 app.rb 파일 생성
- `gem install sinatra`
 

```ruby
# app.rb
require 'sinatra'

get '/' do
    "Hello world !"
end
```

- `ruby app.rb -o $IP`
    - 외부 접속을 허용하기 위해서 IP를 바꿔준다
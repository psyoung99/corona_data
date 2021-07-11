install.packages('Rfacebook')
library(Rfacebook)

## 페이스북에 가입 후 https://developers.facebook.com/tools/explorer 에 접속하여 
## 액세스 토큰을 새롭게 받고 복사해서 아래에 있는 유효기간이 지난 토큰을 지우고 붙여넣기
## 약 2시간만 유효함에 주의. 즉 토큰을 받은 후 2시간이 지나면 새로운 토큰을 요청해야함

fb_oauth="EAACEdEose0cBAHjZAdPEqSnCnOheRs61wh9gQGauM18eC6zVKUDZAyDNp6mNzzP8IsZAHFZAK1dDGj8fZB8FmZCxmB7kcMqtwpMejEYi4IsXwB3k9ZBQDTdpwbzqQyNpahuL395vC1oefnF8JCkYrqx8oESkqi4Wjp0v9A6KlSKQE3GpGRctCIWv6pKejh79IuZCkHkbKw1UwaFhUVVE3Kad"

# pagePost <- getPage(page="SungshinBamboo", token=fb_oauth, since='2017/01/01', until='2017/01/31') # 기간 지정
pagePost <- getPage(page="SungshinBamboo", token=fb_oauth) #기간을 지정하지 않으면 가장 최근의 포스팅을 가져옴

names(pagePost) # 가져온 post 데이터의 변수들을 확인
pagePost <- pagePost[,3] # 3번째 변수인 message만을 선택 
#Sys.setenv(JAVA_HOME="C:/Program Files (x86)/Java/jre1.8.0_131") #JAVA오류가 생기면 이 문장을 실행. 단 Java의 설치 위치 및 버젼 확인
library(KoNLP)
library(wordcloud)
useSejongDic()

df.Post <- data.frame(pagePost, stringsAsFactors = F)  #데이터의 형식을 변환
data.dt <- gsub("[\\n]", "", df.Post) # 줄바꿈 문자 삭제
data.dt <- gsub("http", "", data.dt) # http 삭제
data.dt <- gsub('[0-9]+', "", data.dt) # 숫자 삭제
data.dt <- gsub('성신여대', "", data.dt) # 성신여대 삭제
data.dt <- gsub('숲', "", data.dt) # 숲 삭제
data.dt <- gsub('번째', "", data.dt) # 번째 삭제
data.dt <- data.dt[!is.na(data.dt)] # 값이 들어 있지 않는 포스팅 삭제

nouns <- sapply(data.dt, extractNoun, USE.NAMES = F) # extractNoun의 함수를 data.dt에 적용
nouns <- unlist(nouns) # 데이터 형식 변환
nouns <- nouns[nchar(nouns) >=2] # 길이가 2이상인 단어만 추출
wordCount <- data.frame(table(nouns), stringsAsFactors = F) #데이터 형식 변환

windowsFonts(malgun=windowsFont("맑은 고딕"))  # 한글폰트 사용
pal <- brewer.pal(12, "Paired")

wordcloud(wordCount$nouns, wordCount$Freq, min.freq = 4, random.order=F, family="malgun", colors=pal)



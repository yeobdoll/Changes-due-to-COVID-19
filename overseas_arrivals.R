# To analyze the trend of overseas arrivals

# 엑셀 파일 로드
library(readxl)
entrance_xls <- read_excel("C:/R_data/entrance_exam.xls")

str(entrance_xls)
head(entrance_xls)

# 컬럼명 변경과 공백 제거
colnames(entrance_xls) <- c("country", "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                            "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")

# gsub() 함수를 사용하여 띄어쓰기 제거
entrance_xls$country <- gsub(" ", "", entrance_xls$country)
entrance_xls

# 1월 기준 상위 5개국 추출
entrance_xls |> nrow() # 네이티브 파피프 연산자 (= >%>)
# 총 67개의 국가가 있음을 확인

top5_country <- entrance_xls[order(-entrance_xls$JAN),] |> head(n = 5) # 변수 앞 '-'기호를 사용하여 내림차순 정렬
top5_country

# 데이터 구조 재구조화
library(reshape2)
top5_melt <- melt(top5_country, id.vars = 'country', variable.name = 'mon')
head(top5_melt)

# 데이터 분석: 시각화 진행
library(ggplot2)

ggplot(top5_melt, aes(x=mon, y=value, group=country)) +
  geom_line(aes(color=country))
# 시각화 한 결과 2020년 ~ 2021년에 비해 2022년에는 점점 입국자가 늘어나는 것을 확인할 수 있습니다. 
# 2020년 그래프는 해외 입국자가 많이 줄어드는 것을 확인했습니다. 
# 특히 1월에 비해 3월에 점차 해외 입국자가 늘어나고 미국이 가장 급격하게 늘어난 것을 확인할 수 있습니다. 
# 중국은 다른 나라와 달리 감소하다 6월부터 늘어나는 것을 확인할 수 있었습니다. 

# y축 값이 모호하여 그래프 y축 범위를 조정하였습니다. 
ggplot(top5_melt, aes(x=mon, y=value, group=country)) +
  geom_line(aes(color=country)) +
  ggtitle("2022년 국적별 입국 수 변화 추이") +
  scale_y_continuous(breaks = seq(0, 100000,10000))

# 5개국 전체 해외 입국자 수의 변화를 더 쉽게 파악하기 위해 누적 막대 그래프 변화량으로 시각화 진행
ggplot(top5_melt, aes(x=mon, y=value, fill=country)) +
  geom_bar(stat='identity', position = 'dodge')

ggplot(top5_melt, aes(x=mon, y=value, fill=country)) +
  geom_bar(stat='identity', position = 'stack')

# 2020년 ~ 2021년에 비해 2022년에는 코로나19의 제한이 풀리면서 빠르게 입국자가 늘어나는 것을 분석할 수 있었습니다.
# 다음은 국내 코로나19 선별진료소 위치는 어디인지 지도 시각화 분석을 해볼 예정입니다.
# 코로나19의 이슈가 점점 낮아지면서 코로나19 선별진료소의 수 변화도 보일 것이라 생각이 듭니다. 과연 현재는 어떨까요?

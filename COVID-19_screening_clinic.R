# Analysis of COVID-19 Screening Clinic Location

# 데이터 로드
library(readxl)

xlsdata <- read_excel("C:/R_data/선별진료소_20240117173010.xls") 
head(xlsdata)

str(xlsdata)

# 필요한 정보만 추출
data_raw <- xlsdata[, c(2:5)]
head(data_raw)

names(data_raw)
names(data_raw) <- c("state", "city", "name", "addr")
names(data_raw)

# 데이터 분석 - 빈도분석
table(data_raw$state)
barplot(table(data_raw$state))
# 선별진료소는 경기도에 가장 많고 세종시가 가장 적은 것을 확인할 수 있습니다. 

# 대전 선별진료소 데이터 추출
daejeon_data <- data_raw[data_raw$state == "대전",]
head(daejeon_data)

nrow(daejeon_data)
# 관측치는 414로 앞에서 구한 빈도값 414와 일치하는 것을 알 수 있었습니다. 

# 데이터 분석 - 지도 시각화
# 구글 지도 API를 사용했습니다. 
library(ggmap)

ggmap_key <- "API key 입력"
register_google(ggmap_key)

# dataFrame에서 주소가 있는 열 전체를 가져와야 해서 mutate_geocode() 함수 사용
daejeon_data <- mutate_geocode(data = daejeon_data, location = addr,
                               source = 'google')

head(daejeon_data) # 경도(lon)와 위도(lat)열이 추가된 것을 확인할 수 있습니다.
head(daejeon_data$lon)

# 대전시 지도 시각화
daejeon_map <- get_googlemap('대전', maptype = 'roadmap', zoom = 11)
ggmap(daejeon_map) + 
  geom_point(data = daejeon_data,
             aes(x = lon, y = lat, color = factor(name)), size = 3)

# 마커로 위치 표시하고 위치 이름 넣기
daejeon_data_marker <- data.frame(daejeon_data$lon, daejeon_data$lat)
daejeon_map <- get_googlemap('대전', maptype = 'roadmap', zoom=11, markers = daejeon_data_marker)

ggmap(daejeon_map) +
  geom_text(data=daejeon_data, aes(x=lon, y=lat),
            size = 3, label=daejeon_data$name)

# 데이터를 수집하는 과정에서 알게 되었는데 이제는 코로나19 먹는 치료제가 나왔더군요. 
# 정정하면 해당 데이터는 정확히는 코로나19 먹는치료제 처방 기관에 대한 데이터입니다. 
# 즉, 현재 코로나19 진료가 가능한 곳이라 볼 수 있죠. 과거와 달리 현재는 어느 병원에서나 코로나19 진료가 가능한 것 같습니다.
# 결과는 데이터 수집 날짜에 따라 달라집니다. (참고)
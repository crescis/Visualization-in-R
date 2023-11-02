library(echarts4r)
library(colorspace)
#XY <- fulldata_aqi
XY <- day1full
XY$new <- XY$X6
# 绘图
XY |>
  e_charts(x = lng) |>
  e_geo(
    roam = TRUE,
    map = "world",
    boundingCoords = list(
      c(-170, 0),
      c(0, 70)
    )
  ) |>
  e_scatter(
    serie = lat,
    scale = NULL, # 去掉尺度变换
    size = new, 
    symbol = 'circle',
    coord_system = "geo"
  ) |>
  
  e_visual_map(
    serie = new, 
    left = 0, bottom = 0, # 图例的位置，离容器右侧和下侧的距离
    text  = c("high", "low"), # 定义两端的文本
    textStyle = list(color = "white"),
    inRange = list(
      color = c('lightgreen','yellow', 'red','purple'),
      #color = hcl.colors(5,palette=hcl.pals()[15]), # 填充颜色
      #color = c("#1e5670","#4198b9","#6bb3c0","#91cfc9","#cde8f3"),
      #color = rainbow_hcl(5),
      colorAlpha = 1, # 设置透明度
      symbolSize = c(12, 12) # 设置气泡大小
      
    )
  ) |>
  e_theme(name = "chalk")



fulldata_aqi$new <- fulldata_aqi$idx
# 绘图
fulldata_aqi |>
  e_charts(x = lng) |>
  e_geo(
    roam = TRUE,
    map = "world",
    boundingCoords = list(
      c(-170, 0),
      c(0, 70)
    )
  ) |>
  e_scatter(
    serie = lat,
    scale = NULL, # 去掉尺度变换
    size = new, 
    symbol = 'pin',
    coord_system = "geo"
  ) |>
  
  e_visual_map(
    serie = new, 
    left = 0, bottom = 0, # 图例的位置，离容器右侧和下侧的距离
    text  = c("high", "low"), # 定义两端的文本
    textStyle = list(color = "white"),
    inRange = list(
      color = hcl.colors(5,palette=hcl.pals()[15]), # 填充颜色
      colorAlpha = 1, # 设置透明度
      symbolSize = c(9, 9) # 设置气泡大小
      
    )
  ) |>
  e_theme(name = "chalk")
 
library(plotly)
plotly::plot_ly(
  data = day1full,
  type = "choropleth",
  locations = ~county_fips, # 两个字母的州名缩写
  locationmode = "USA-states", # 地理几何地图数据
  colorscale = "Viridis", # 其它调色板如 "RdBu"
  z = ~X6
) |>
  plotly::colorbar(title = "人口") |> 
  plotly::layout(
    geo = list(scope = "usa"),
    title = "1974年美国各州的人口"
  ) |>
  plotly::config(displayModeBar = FALSE)

library(usmap)
day1us <- merge(aqidata,uscounties,by='fullname')
day1us <- data.frame(cbind(day1us$county_fips,day1us$AQI))
colnames(day1us) <- c('fips','values')
plot_usmap(data = day1us)
group <- unique(aqidata$fullname)
day1 <- data.frame(matrix(0,2000,11))
for (i in 1:length(group)){
  day1[i,] <- subset(aqidata,fullname == group[i] & Date == '2021-01-01')[1,]
}
day1 <- na.omit(day1)
day1full <- merge(day1,uscounties,by.x = 'X11', by.y = 'fullname')

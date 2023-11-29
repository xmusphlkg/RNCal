source("ui/notice.R", encoding = "UTF-8")
source("ui/data_input.R", encoding = "UTF-8")
source("ui/basic_RN.R", encoding = "UTF-8")
source("ui/real_RN.R", encoding = "UTF-8")

# 调用函数检查主机位置
check_host_location <- function(host) {
  cmd <- paste("ping -c 1 -W 0.1", host)
  result <- system(cmd, intern = TRUE)
  
  if (any(grepl("1 packets transmitted, 1 received", result))) {
    return("服务位置：曾宪梓楼物理机房")
  } else {
    return("服务位置：云服务机房")
  }
}
host_location <- check_host_location("192.168.10.1")

fluidPage(
  tags$header(
    tags$style(".container-fluid{padding-left: 0px;padding-right: 0px;}"),
    tags$style(".navbar-brand{padding-left: 50px;}"),
    tags$style(HTML("a {color: #28b78d}")),
    tags$style(type = "text/css", "body {padding-top: 70px;}")
  ),
  navbarPage(
    title = "再生数计算器",
    id = "tabs",
    theme = shinytheme(theme = "united"),
    inverse = F,
    collapsible = T,
    position = "fixed-top",
    header = tagList(
      useShinydashboard(),
      useShinyalert(force = T),
      setBackgroundColor(color = "ghostwhite"),
      disconnectMessage(
        text = "应用出错了，请刷新网页重试或者联系技术支持",
        refresh = "刷新",
        background = "#000000",
        colour = "#FFFFFF",
        refreshColour = "#337AB7",
        overlayColour = "#000000",
        overlayOpacity = 1,
        width = "full",
        top = "center",
        size = 24,
        css = ""
      ),
      includeHTML("ui/googleanalytics.html")
    ),
    tabPanel(title = "Notice", tab_notice, value = "Notice"),
    tabPanel(
      title = "关于",
      fluidPage(column(
        width = 12,
        offset = 2,
        box(
          width = 8,
          includeMarkdown("README.md")
        )
      ))
    )
  ),
  tags$footer(HTML(paste0("<footer class='page-footer font-large indigo'>
                           <div class='footer-copyright text-center py-3'>Copyright © 厦门大学公共卫生学院流行病学课题组
                           <br>
                           <a href='mailto:ctmodelling@outlook.com'> 技术支持</a>
                           <br>
                           <span>",
                          host_location,
                          "</span>
                           <br>
                           备案号：<a href='https://beian.miit.gov.cn/' target='_blank'>湘ICP备2023013915号-2</a></p>
                           </div>
                           </footer>")),
    class = "footer",
    style = "background-color:#E95420; color: white; height:100px; padding: 10px;"
  )
)
source('ui/notice.R', encoding = 'UTF-8')
source('ui/data_input.R', encoding = 'UTF-8')
source('ui/basic_RN.R', encoding = 'UTF-8')
source('ui/real_RN.R', encoding = 'UTF-8')

navbarPage(
  title = '再生数计算器',
  id = 'tabs',
  theme = shinytheme(theme = 'united'),
  inverse = F,
  header = tagList(
    useShinydashboard(),
    useShinyalert(),
    setBackgroundColor(color = 'ghostwhite'),
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
    )
    # includeHTML('ui/googleanalytics.html')
  ),
  tabPanel(title = 'Notice', tab_notice, value = 'Notice'),
  tabPanel(title = '关于',
           fluidPage(includeMarkdown('ui/about.md')))
)

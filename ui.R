
source('ui/notice.R', encoding = 'utf-8')
source('ui/data_input.R', encoding = 'utf-8')
source('ui/basic_RN.R', encoding = 'utf-8')
source('ui/real_RN.R', encoding = 'utf-8')

navbarPage(
  title = '再生数计算器',
  id = 'tabs',
  theme = shinytheme(theme = 'united'),
  inverse = F,
  header = tagList(
    useShinydashboard(),
    setBackgroundColor(color = 'ghostwhite'),
    # includeHTML('function/googleanalytics.html')
  ),
  tabPanel(title = 'Notice', tab_notice, value = 'Notice'),
  tabPanel(title = '关于', 
           fluidPage(
             includeMarkdown('ui/about.md')
           ))
)


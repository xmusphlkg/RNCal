tab_notice <- tabPanelBody(value = 'Notice',
                           tags$head(
                             tags$style(".butt{background-color:#E95420; color: white; width: 100%}")
                           ),
                           fluidRow(column(
                             width = 12,
                             offset = 2,
                             box(
                               width = 8,
                               includeMarkdown('ui/aggrement.md'),
                               div(actionBttn(
                                 inputId = 'Tab_dataload',
                                 label = '同意并开始数据导入',
                                 icon = icon('check'),
                                 color = 'success'
                               ),
                               style = "position:absolute;right:25px; bottom:25px;")
                               )
                           )))
tab_notice <- tabPanelBody(
  value = 'Notice',
  tags$head(tags$style(".butt{background-color:#E95420; color: white; width: 100%}")),
  fluidRow(
    column(
      width = 12,
      offset = 2,
      box(
        title = '使用须知',
        width = 8,
        includeMarkdown('ui/aggrement.md'),
        br(),
        column(
          width = 12,
          align = 'right',
          actionBttn(
            inputId = 'Tab_dataload',
            label = '同意并开始数据导入',
            icon = icon('check'),
            color = 'success'
          )
        )
      )
    )
  )
)
data_input <- tabPanelBody(
  value = 'Data_input',
  tags$head(tags$style(".butt{background-color:#E95420; color: white; width: 100%}")),
  fluidRow(
    column(width = 3,
           box(title = "原始数据",
               width = 12,
               footer = "分类仅用于绘制流行曲线，不影响再生数计算",
               status = 'warning',
               rHandsontableOutput('data_raw'),
               fileInput(inputId = 'input_rawdata',
                         label = " ",
                         placeholder = 'xlsx导入',
                         buttonLabel = '打开文件',
                         accept = '.xlsx',
               ))),
    column(width = 1, align="center",
           actionBttn(inputId = 'trans_raw',
                      size = 'sm',
                      color = 'warning',
                      icon = icon('random'),
                      style = 'material-flat',
                      label = '转换'),
           tags$style(type='text/css', "#trans_raw { vertical-align: middle;}")),
    column(width = 3,
           box(title = "数据输入",
               width = 12,
               footer = "分类仅用于绘制流行曲线，不影响再生数计算",
               status = 'warning',
               rHandsontableOutput("data_input"),
               fileInput(inputId = 'input_transdata',
                         label = " ",
                         placeholder = 'xlsx导入',
                         buttonLabel = '打开文件',
                         accept = '.xlsx',
                         ))),
    column(width = 1, align='center',
           actionBttn(inputId = 'trans_input',
                      size = 'sm',
                      color = 'warning',
                      icon = icon('eye'),
                      style = 'material-flat',
                      label = '预览'),
           tags$style(type='text/css', "#trans_input { vertical-align: middle;}")),
    column(width = 4,
           box(title = "数据预览",
               width = 12,
               status = 'warning',
               column(width = 12,
                      align="center",
                      plotOutput('data_preview')),
               actionBttn(
                 inputId = 'Epicurve_download',
                 label = '结果下载',
                 size = 'sm',
                 color = 'warning',
                 icon = icon("download"),
               ))
           )
  ),
  fluidRow(
    column(
      width = 12,
      align = 'right',
      actionBttn(
        inputId = 'Tab_R0_1',
        label = '计算R0',
        icon = icon('check'),
        color = 'success'
      ),
      actionBttn(
        inputId = 'Tab_Rt_1',
        label = '计算Rt',
        icon = icon('check'),
        color = 'success'
      )
    )
  )
)
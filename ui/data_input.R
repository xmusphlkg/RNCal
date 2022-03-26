data_input <- tabPanelBody(
  value = 'Data_input',
  tags$head(
    tags$style(".butt{background-color:#E95420; color: white; width: 100%}")
  ),
  fluidRow(
    column(
      width = 12,
      tags$style(type = 'text/css', ".butt.pull-left {position: absolute; left: 0; top: 0;}"),
      box(
        title = p("原始数据",
                  actionButton(inputId = 'trans_raw',
                               icon = icon('random'),
                               class = "btn-sm", 
                               label = "转换", 
                               style = "background-color:#E95420; color: white; position: absolute; right: 10px; top:5px;")),
        width = 3,
        footer = HTML("分类仅用于绘制流行曲线，不影响再生数计算\n日期格式为“月/日/年”，建议直接从excel中复制粘贴"),
        status = 'warning',
        rHandsontableOutput('data_raw', height = '400px'),
        fileInput(
          inputId = 'input_rawdata',
          label = " ",
          placeholder = 'xlsx导入',
          buttonLabel = '打开文件',
          accept = '.xlsx',
        )
      ),
      box(
        title = p("数据输入",
                  actionButton(inputId = 'trans_input',
                               icon = icon('eye'),
                               class = "btn-sm", 
                               label = "预览", 
                               style = "background-color:#E95420; color: white; position: absolute; right: 10px; top:5px;")),
        width = 3,
        footer = HTML("分类仅用于绘制流行曲线，不影响再生数计算\n日期格式为“月/日/年”，建议直接从excel中复制粘贴"),
        status = 'warning',
        rHandsontableOutput("data_input", height = '400px'),
        fileInput(
          inputId = 'input_transdata',
          label = " ",
          placeholder = 'xlsx导入',
          buttonLabel = '打开文件',
          accept = '.xlsx',
        )
      ),
      box(
        title = p("数据预览",
                  actionButton(inputId = 'epicurvehelper',
                               icon = icon('question'),
                               class = "btn-sm", 
                               label = "流行曲线太丑？试试我们的新工具", 
                               onclick ="window.open('http://toolbox.ctmodelling.cn/app/EpicurveHelper', '_blank')",
                               style = "background-color:#E95420; color: white; position: absolute; right: 10px; top:5px;")),
        width = 6,
        status = 'warning',
        column(
          width = 12,
          align = "center",
          plotOutput('data_preview', height = '525px')
        ),
        column(width = 4,
               actionBttn(
                 inputId = 'Epicurve_download',
                 label = '结果下载',
                 color = 'warning',
                 icon = icon("download"),
               )),
        column(width = 8,
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
               ))
      )
    )
  )
)
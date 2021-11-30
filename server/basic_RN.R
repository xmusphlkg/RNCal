
# earlyR ------------------------------------------------------------------

## ui setting -----------

observeEvent(input$earlyR_si_data,{
  if(input$earlyR_si_data != 'NULL'){
    value <- input$earlyR_si_data
    value <- as.numeric(str_split(value,'-')[[1]])
    updateNumericInput(
      session = session,
      inputId = 'earlyR_si_mean',
      label = '代间距(SI)均数',
      value = value[2]
    )
    updateNumericInput(
      session = session,
      inputId = 'earlyR_si_std',
      label = '代间距(SI)标准差',
      value = value[1]
    )
  }
})

## estimate R0 -----------

observeEvent(input$earlyR_si_confirmed, {
  if(is.null(values$df_global)){
    shinyalert("提交失败", "原因：未找到原始数据，请在数据输入
                           界面点击'转换'或者'绘图'后重试！", 
                           timer = 5000 , 
               type = "error",
               size = 'xs')
    
  }else if(is.na(input$earlyR_si_mean)){
    shinyalert("提交失败", "原因：关键参数缺失！", 
               timer = 5000 , 
               type = "error",
               size = 'xs')
    
  }else if(is.na(input$earlyR_si_std)){
    shinyalert("提交失败", "原因：关键参数缺失！", 
               timer = 5000 , 
               type = "error",
               size = 'xs')
    
  }else{
    datafile <- values$df_plot
    si_mean <- input$earlyR_si_mean
    si_sd <- input$earlyR_si_std
    outcome <- get_R(incidence(datafile$onset),
                     si_mean = si_mean,
                     si_sd = si_sd)
    fig <- plot(outcome)+theme_set()
    figs$fig_earlyR_R0 <- fig
    
    output$fig_earlyR_R0 <- renderPlot({
      fig
    })
  }
})

## download------

# observeEvent(input$R0_earlyR_download,{
#   if (!is.null(figs$fig_earlyR_R0)){
#     showModal(
#       modalDialog(
#         fluidRow(
#           column(
#             width = 12,
#             align = "center",
#             downloadButton(
#               "download_earlyR_png",
#               "下载结果(png)",
#               icon = icon("file-image"),
#               class = 'butt'
#             )
#           )
#         ),
#         br(),
#         fluidRow(
#           column(
#             width = 12,
#             align = "center",
#             downloadButton(
#               "download_earlyR_tiff",
#               "下载结果(tiff)",
#               icon = icon("file-image"),
#               class = 'butt'
#             )
#           )
#         ),
#         br(),
#         fluidRow(
#           column(
#             width = 12,
#             align = "center",
#             downloadButton(
#               "download_earlyR_pdf",
#               "下载结果(PDF)",
#               icon = icon("file-pdf"),
#               class = 'butt'
#             )
#           )
#         ),
#         title = "下载",
#         size = "s",
#         footer = list(
#           modalButton("取消")
#         )
#       )
#     )
# 
#     output$download_earlyR_png <- downloadHandler(
#       filename = function(){
#         paste0("outcome", Sys.Date(), ".png")
#       },
#       content = function(file) {
#         ggsave(file, plot = figs$fig_earlyR_R0, device = 'png')
#       }
#     )
# 
#     output$download_earlyR_tiff <- downloadHandler(
#       filename = function(){
#         paste0("outcome", Sys.Date(), ".tiff")
#       },
#       content = function(file) {
#         ggsave(file, plot = figs$fig_earlyR_R0, device = 'tiff')
#       }
#     )
# 
#     output$download_earlyR_pdf <- downloadHandler(
#       filename = function(){
#         paste0("outcome", Sys.Date(), ".pdf")
#       },
#       content = function(file) {
#         pdf(file)
#         figs$fig_earlyR_R0
#         dev.off()
#       }
#     )
# 
#   } else {
#     shinyalert("提交失败", "原因：图片不存在！",
#                timer = 5000 ,
#                type = "error",
#                size = 'xs')
#   }
# })



# R0 ----------------------------------------------------------------------

observeEvent(input$R0_gt_data,{
  if(input$R0_gt_data != 'NULL'){
    value <- input$R0_gt_data
    value <- as.numeric(str_split(value,'-')[[1]])
    
    updateNumericInput(
      session = session,
      inputId = 'R0_gt_mean',
      label = '代间距(GT)均数',
      value = value[2]
    )
    updateNumericInput(
      session = session,
      inputId = 'R0_gt_std',
      label = '代间距(GT)标准差',
      value = value[1]
    )
  }
})

output$R0_gt_data_detail_1 <- renderRHandsontable({
  DF <- data.frame(
    "传染者发病时间" = rep(0,length(H1N1.serial.interval)),
    "感染者发病时间" = H1N1.serial.interval
  )
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) %>% 
    hot_cols(colWidths = 130, format = "0")
})

output$R0_gt_data_si_1 <- renderRHandsontable({
  DF <- as.data.frame(table(H1N1.serial.interval))
  names(DF) <- c('Serial interval', 'Freq')
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) %>% 
    hot_cols(colWidths = 130, format = "0")
})


observeEvent(input$R0_gt_data_confirmed_1,{
  
  if(input$R0_gt_input_type_1 == 'SI'){
    df <- hot_to_r(input$R0_gt_data_si_1)
    df <- df[rep(row.names(df), df$Freq), 1]
    df_gt <- suppressMessages(suppressWarnings(est.GT(serial.interval = as.numeric(df))))
    values$R0_gt <- df_gt
    output$R0_gt_data_1 <- renderPrint(print(df_gt))
  }
  
  if(input$R0_gt_input_type_1 == 'detail'){
    df <- hot_to_r(input$R0_gt_data_detail_1)
    df_gt <- suppressMessages(suppressWarnings(est.GT(
      infector.onset.dates = df$传染者发病时间,
      infectee.onset.dates = df$感染者发病时间
    )))
    values$R0_gt <- df_gt
    output$R0_gt_data_1 <- renderPrint(print(df_gt))
  }
  
  if(input$R0_gt_input_type_1 == 'GT'){
    df <- input$R0_gt_data_gt_content_1
    df <- str_extract_all(df, "\\d+\\.*\\d*")[[1]]
    df <- df[df != '']
    # df <- str_squish(df)
    if(length(df) != 0){
      df_gt <- suppressMessages(suppressWarnings(generation.time(
        type = input$R0_gt_data_gt_type,
        val = as.numeric(df)
      )))
      values$R0_gt <- df_gt
      output$R0_gt_data_1 <- renderPrint(print(df_gt))
    } else {
      shinyalert("提交失败", "原因：关键参数缺失！", 
                 timer = 5000 , 
                 type = "error",
                 size = 'xs')
    }
  }
})

observeEvent(input$R0_gt_data_gt_example_1,{
  updatePickerInput(
    session = session,
    inputId = 'R0_gt_data_gt_type_1',
    label = 'GT分布',
    choices = c("empirical", "gamma", "weibull", "lognormal"),
    selected = 'gamma'
  )
  updateTextAreaInput(
    session = session,
    inputId = 'R0_gt_data_gt_content_1',
    label = 'values(使用半角的 , 分割)',
    value = "2.45, 1.38"
  )
})

# est.R0 ------------------------------------------------------------------

observeEvent(input$R0_R0_confirmed,{
  begin <- input$R0_est_begin
  end <- input$R0_est_end
  datafile <- values$df_global
  df_gt <- values$R0_gt
  if(input$R0_est_function == 'EG') {
    df_R0 <- est.R0.EG(datafile$X, df_gt, begin=begin, end=end)
  }
  if(input$R0_est_function == 'ML') {
    df_R0 <- est.R0.ML(datafile$X, df_gt, begin=begin, end=end, range = c(0.01, 50))
  }
  
  output$R0_est_R0 <- renderPrint(print(df_R0))

  output$fig_R0_R0 <- renderPlot({
    plot(df_R0)
  })
})

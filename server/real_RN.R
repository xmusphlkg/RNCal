
# EpiEstim ----------------------------------------------------------------

values$R0_gt <- NULL

observeEvent(input$epiestim_parametric_si_data,{
  if(input$epiestim_parametric_si_data == "Delta_广东"){
    updateNumericInput(
      inputId = 'epiestim_parametric_si_std',
      label = '代间距(SI)标准差',
      value = 3.4
    )
    updateNumericInput(
      inputId = 'epiestim_parametric_si_mean',
      label = '代间距(SI)均数',
      value = 2.3
    )
  }
})

observeEvent(input$EpiEstim_rt_confirmed,{
  mean_si <- input$epiestim_parametric_si_mean
  std_si <- input$epiestim_parametric_si_std
  datafile <- values$df_plot %>% 
    group_by(onset) %>% 
    summarise(X = n())
  start_date <- input$epiestim_parametric_si_first
  space_date <- input$epiestim_parametric_si_width
  
  start_dates <- seq(start_date, nrow(datafile)-space_date)
  end_dates <- start_dates + space_date
  
  config_lit <- make_config(
    list(mean_si = mean_si,
         std_si = std_si,
         t_start = start_dates,
         t_end = end_dates)
  )
  
  names(datafile) <- c('dates', 'I')
  date_st <- min(datafile$dates)
  epiestim_res_lit <- estimate_R(
    incid = datafile,
    method = "parametric_si",
    config = config_lit
  )
  
  outcome <- epiestim_res_lit$R
  outcome$date <- (outcome$t_start + outcome$t_end)/2 + date_st
  outcome$t_start <- date_st + outcome$t_start
  outcome$t_end <- date_st + outcome$t_end
  
})



output$non_parametric_si_data <- renderRHandsontable({
  DF <- data.frame(
    天数 = 1:12,
    频数 = c(0, rep(0.1, 10), 0)
  )
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

output$non_si_from_sample_data <- renderRHandsontable({
  DF <- MockRotavirus$si_data
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

output$non_si_from_data_data <- renderRHandsontable({
  DF <- MockRotavirus$si_data
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

observeEvent(input$confirmed_packages,{
  if(input$select_packages == 'EpiEstim'){
    if(input$epiestim_method == "parametric_si"){
      
      
      
      start_dates <- seq(2,nrow(df)-4)
      end_dates <- start_dates + 4
      
      config_lit <- make_config(
        list(mean_si = 2.3,
             std_si = 3.4,
             t_start = start_dates,
             t_end = end_dates)
      )
    }
  }
})


# output$R0_gt_data_si <- renderRHandsontable({
#   DF <- data.frame(SI = H1N1.serial.interval)
#   rhandsontable(DF, language = 'zh-CN') %>% 
#     hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
# })

# R0 ----------------------------------------------------------------------

output$R0_gt_data_detail <- renderRHandsontable({
  DF <- data.frame(
    "传染者发病时间" = rep(0,length(H1N1.serial.interval)),
    "感染者发病时间" = H1N1.serial.interval
  )
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) %>% 
    hot_cols(colWidths = 130, format = "0")
})

output$R0_gt_data_si <- renderRHandsontable({
  DF <- as.data.frame(table(H1N1.serial.interval))
  names(DF) <- c('Serial interval', 'Freq')
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})


observeEvent(input$R0_gt_data_confirmed,{
  
  if(input$R0_gt_input_type_2 == 'SI'){
    df <- hot_to_r(input$R0_gt_data_si)
    df <- df[rep(row.names(df), df$Freq), 1]
    df_gt <- suppressMessages(suppressWarnings(est.GT(serial.interval = as.numeric(df))))
    values$R0_gt <- df_gt
    output$R0_gt_data <- renderPrint(print(df_gt))
  }
  
  if(input$R0_gt_input_type_2 == 'detail'){
    df <- hot_to_r(input$R0_gt_data_detail)
    df_gt <- suppressMessages(suppressWarnings(est.GT(
      infector.onset.dates = df$传染者发病时间,
      infectee.onset.dates = df$感染者发病时间
    )))
    values$R0_gt <- df_gt
    output$R0_gt_data <- renderPrint(print(df_gt))
  }
  
  if(input$R0_gt_input_type_2 == 'GT'){
    df <- input$R0_gt_data_gt_content
    df <- str_extract_all(df, "\\d+\\.*\\d*")[[1]]
    # df <- str_squish(df)
    if(length(df) != 0){
      df_gt <- suppressMessages(suppressWarnings(generation.time(
        type = input$R0_gt_data_gt_type,
        val = as.numeric(df)
      )))
      values$R0_gt <- df_gt
      output$R0_gt_data <- renderPrint(print(df_gt))
    } else {
      shinyalert("提交失败", "原因：关键参数缺失！", 
                 timer = 5000 , 
                 type = "error",
                 size = 'xs')
    }
  }
})

observeEvent(input$R0_gt_data_gt_example,{
  updatePickerInput(
    session = session,
    inputId = 'R0_gt_data_gt_type',
    label = 'GT分布',
    choices = c("empirical", "gamma", "weibull", "lognormal"),
    selected = 'gamma'
  )
  updateTextAreaInput(
    session = session,
    inputId = 'R0_gt_data_gt_content',
    label = 'values(使用半角的 , 分割)',
    value = "2.45, 1.38"
  )
})


observeEvent(input$R0_Rt_confirmed,{
  gt <- values$R0_gt
  df <- values$df_plot %>% 
    group_by(onset) %>% 
    summarise(X = n())
  df_value <- df$X
  names(df_value) <- df$onset
  if(input$R0_Rt_est_function == 'TD'){
    df_Rt <- est.R0.TD(df_value, gt, 
                       begin=1, 
                       end=as.numeric(length(df_value)), 
                       nsim=input$R0_TD_nsim)
    if(is.null(input$R0_Rt_smooth)) {
      df_Rt <- smooth.Rt(df_Rt, 7)
    }
    datafile <- data.frame(
      date = df_Rt$epid$t,
      Rt = df_Rt$R,
      Rt_lower = df_Rt$conf.int$lower,
      Rt_upper = df_Rt$conf.int$upper
    )
    values$df_Rt <- datafile
  }
  if(input$R0_Rt_est_function == 'SB'){
    df_Rt <- est.R0.SB(df$X, gt)
    datafile <- data.frame(
      date = seq.Date(from = df_Rt$begin, to = df_Rt$end - 1, by = 'day'),
      Rt = df_Rt$R,
      Rt_lower = df_Rt$conf.int$CI.lower.,
      Rt_upper = df_Rt$conf.int$CI.upper.
    )
    values$df_Rt <- datafile
  }
  
  date_breaks <- values$date_breaks
  
  fig <- ggplot(data = datafile, mapping = aes(x = date))+
    geom_ribbon(mapping = aes(ymin = Rt_lower, ymax = Rt_upper, fill = 'red'),
                alpha = 0.3, show.legend = F)+
    geom_line(mapping = aes(y = Rt, color = 'red'), size = 1, show.legend = F)+
    geom_line(mapping = aes(y = 1), color = 'black', size = 1, linetype="dashed", show.legend = F)+
    # geom_text(mapping = aes(x = max(date)+1, y = 1, label = 'R[t]==1.0'), parse=T)+
    annotate('text', x = max(datafile$date), y = 1, size = 12/.pt,
             label = expression(R[t]==1),
             hjust = 0,
             fontface = "bold",
             family= 'Times New Roman')+
    scale_x_date(
      expand = c(0,0),
      date_labels = "%m月%d日",
      date_breaks = date_breaks)+
    scale_y_continuous(expand = c(0,0))+
    labs(x = "", y = expression(R[t]))+
    theme_set()+
    # theme(plot.margin=unit(c(1,3,1,1),'lines'))+
    coord_cartesian(clip = "off")
  fig
})

# EpiNow2 -----------------------------------------------------------------

observeEvent(input$select_packages, {
  if(input$select_packages == "EpiNow2"){
    showModal(
      modalDialog(
        title = "Sorry",
        fluidRow(
          column(
            width = 12,
            h3('抱歉，这个包怎么用我还搞不清。'),
            br(),
            h4("如果你会的话，欢迎联系技术支持，感谢~"),
            a(href="fjmulkg@outlook.com", "技术支持")
          )
        ),
        size = 'l',
        footer = list(
          modalButton("确定")
        )
      )
    )
  }
})



## incubation period --------
output$EpiNow2_incubation_data <- renderRHandsontable({
  DF <- data.frame(
    "发病时间" = linelist$date_onset[1:10],
    "感染时间" = linelist$date_infection[1:10]
  )
  rhandsontable(DF, language = 'zh-CN') %>% 
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE) %>% 
    hot_cols(colWidths = 100, format = "0")
})

observeEvent(input$EpiNow2_incubation_period_confirmed, {
  incubation_period <- NULL
  
  if(input$EpiNow2_incubation_period_type == 'fit'){
    DF <- hot_to_r(input$EpiNow2_incubation_data)
    names(DF) <- c('date_onset', 'date_infection')
    
    dist <- input$input.EpiNow2_incubation_dist
    max_value <- input$input.EpiNow2_incubation_max
    
    incubation_period <- bootstrapped_dist_fit(
      DF$date_onset - DF$date_infection,
      dist = dist,
      max_value = max_value,
      bootstraps = 1
    )
  }
  
  if(input$EpiNow2_incubation_period_type == 'input'){
    incubation_period <- list(
      mean = log(input$input.EpiNow2_incubation_mean),
      mean_sd = log(input$input.EpiNow2_incubation_mean_sd),
      sd = log(input$input.EpiNow2_incubation_sd),
      sd_sd = log(input.EpiNow2_incubation_sd_sd),
      max = input$EpiNow2_incubation_max
    )
  }
  
  if(input$EpiNow2_incubation_period_type == 'example'){
    incubation_period <- get_incubation_period(disease = "SARS-CoV-2", source = "lauer")
  }
  
  output$EpiNow2_incubation_period_outcome <- renderPrint({
    print("潜伏期设置")
    print(incubation_period)
  })
  showModal(
    modalDialog(
      title = "EpiNow2设置",
      fluidRow(
        column(
          width = 6,
          verbatimTextOutput('EpiNow2_incubation_period_outcome', placeholder = T),
        ),
        column(
          width = 6,
          verbatimTextOutput('EpiNow2_generation_times_outcome', placeholder = T),
        )
      ),
      size = 'l',
      footer = list(
        modalButton("确定")
      )
    )
  )
  
  values$EpiNow2_incubation_period <- incubation_period
})

## generation times --------

observeEvent(input$EpiNow2_gt_confirmed, {
  generation_times <- NULL
  
  if(input$EpiNow2_gt_input_type == 'example'){
    generation_times <- get_generation_time(disease = "SARS-CoV-2", source = "ganyani")
  }
  
  if(input$EpiNow2_gt_input_type == 'GT'){
    generation_times <- list(
      mean = log(input$input.EpiNow2_gt_input_mean),
      mean_sd = log(input$input.EpiNow2_gt_input_mean_sd),
      sd = log(input$input.EpiNow2_gt_input_sd),
      sd_sd = log(input.EpiNow2_gt_input_sd_sd),
      max = input$EpiNow2_gt_input_max
    )
  }
  
  output$EpiNow2_generation_times_outcome <- renderPrint({
    print("代间距设置")
    print(generation_times)
  })
  
  showModal(
    modalDialog(
      title = "EpiNow2设置",
      fluidRow(
        column(
          width = 6,
          verbatimTextOutput('EpiNow2_incubation_period_outcome', placeholder = T),
        ),
        column(
          width = 6,
          verbatimTextOutput('EpiNow2_generation_times_outcome', placeholder = T),
        )
      ),
      size = 'l',
      footer = list(
        modalButton("确定")
      )
    )
  )
  
  values$EpiNow2_generation_times <- generation_times
})
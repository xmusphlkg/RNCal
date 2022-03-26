

# EpiEstim ----------------------------------------------------------------

values$R0_gt <- NULL

observeEvent(input$epiestim_parametric_si_data, {
  if (input$epiestim_parametric_si_data == "Delta_广东") {
    updateNumericInput(inputId = 'epiestim_parametric_si_std',
                       label = '代间距(SI)标准差',
                       value = 3.4)
    updateNumericInput(inputId = 'epiestim_parametric_si_mean',
                       label = '代间距(SI)均数',
                       value = 2.3)
  }
})

# parametric_si -----------------------------------------------------------

observeEvent(input$EpiEstim_parametric_confirmed, {
  mean_si <- input$epiestim_parametric_si_mean
  std_si <- input$epiestim_parametric_si_std
  start_date <- as.numeric(input$epiestim_parametric_si_first)
  space_date <- as.numeric(input$epiestim_parametric_si_width)
  
  if (is.na(mean_si) |
      is.na(std_si) | is.na(start_date) | is.na(space_date)) {
    shinyalert(
      "提交失败",
      "原因：关键参数缺失！",
      timer = 5000 ,
      type = "error",
      size = 'xs'
    )
  } else{
    datafile <- values$df_global %>%
      group_by(t) %>%
      summarise(X = sum(X), .groups = 'drop')
    
    start_dates <- seq(start_date, nrow(datafile) - space_date)
    end_dates <- start_dates + space_date
    config_lit <- make_config(list(
      mean_si = mean_si,
      std_si = std_si,
      t_start = start_dates,
      t_end = end_dates
    ))
    names(datafile) <- c('dates', 'I')
    date_st <- min(datafile$dates)
    
    withCallingHandlers(
      tryCatch({
        epiestim_res_lit <- estimate_R(incid = datafile,
                                       method = "parametric_si",
                                       config = config_lit)
        epiestim_res_lit$check <- NA
      },
      error = function(err) {
        showNotification(paste0(err), type = 'err')
        epiestim_res_lit$check <- 'ERROR'
      }),
      warning = function(warn) {
        showNotification(paste0(warn), type = 'warning')
        invokeRestart("muffleWarning")
      })
    
    if(anyNA(epiestim_res_lit$check)){
      outcome <- epiestim_res_lit$R
      outcome$date <- (outcome$t_start + outcome$t_end) / 2 + date_st
      outcome$t_start <- date_st + outcome$t_start
      outcome$t_end <- date_st + outcome$t_end
      
      date_breaks <- values$date_breaks
      
      fig <- ggplot(data = outcome, mapping = aes(x = date)) +
        geom_ribbon(
          mapping = aes(
            ymin = `Quantile.0.025(R)`,
            ymax = `Quantile.0.975(R)`,
            fill = 'red'
          ),
          alpha = 0.3,
          show.legend = F
        ) +
        geom_line(
          mapping = aes(y = `Median(R)`, color = 'red'),
          size = 1,
          show.legend = F
        ) +
        geom_line(
          mapping = aes(y = 1),
          color = 'black',
          size = 1,
          linetype = "dashed",
          show.legend = F
        ) +
        # geom_text(mapping = aes(x = max(date)+1, y = 1, label = 'R[t]==1.0'), parse=T)+
        annotate(
          'text',
          x = max(outcome$date),
          y = 1,
          size = 12 / .pt,
          label = expression(R[t] == 1),
          hjust = 0,
          fontface = "bold"
        ) +
        scale_x_date(
          expand = c(0, 0),
          date_labels = "%m/%d",
          date_breaks = date_breaks
        ) +
        scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                           limits = c(0, NA)) +
        labs(x = "", y = expression(R[t])) +
        theme_set() +
        # theme(plot.margin=unit(c(1,3,1,1),'lines'))+
        coord_cartesian(clip = "off")
      
      figs$fig_Rt <- fig
      values$df_Rt <- outcome
      output$fig_EpiEstim_Rt <- renderPlot({
        fig
      })
    }
  }
})

# non_parametic confirmed -------------------------------------------------

output$non_parametric_si_data <- renderRHandsontable({
  DF <- data.frame(
    天数  = 1:12,
    频数  = sample(1:5, size = 12, replace = T))
  rhandsontable(DF, language = 'zh-CN') %>%
    hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
})

observeEvent(input$EpiEstim_non_parametric_confirmed, {
  si_distr <- hot_to_r(input$non_parametric_si_data)
  names(si_distr) <- c('n', 'freq')
  # browser()
  withCallingHandlers(
    tryCatch({
      si_distr <- si_distr %>%
        complete(n = seq(min(n), max(n)),
                 fill = list(freq = 0)) %>%
        mutate(freq = freq / sum(freq))
      start_date <- as.numeric(input$epiestim_non_parametric_si_first)
      space_date <- as.numeric(input$epiestim_non_parametric_si_width)
      datafile <- values$df_global %>%
        group_by(t) %>%
        summarise(X = sum(X))
      names(datafile) <- c('dates', 'I')
      
      date_st <- min(datafile$dates)
      si_distr <- as.numeric(si_distr$freq)
      start_dates <- seq(start_date, nrow(datafile) - space_date)
      end_dates <- start_dates + space_date
      
      config_lit <- make_config(list(
        si_distr = c(0, si_distr),
        t_start = start_dates,
        t_end = end_dates
      ))
      
      epiestim_res_lit <- estimate_R(incid = datafile,
                                     method = "non_parametric_si",
                                     config = config_lit)
      epiestim_res_lit$check <- NA
    },
    error = function(err) {
      showNotification(paste0(err), type = 'err')
      epiestim_res_lit$check <- 'ERROR'
    }),
    warning = function(warn) {
      showNotification(paste0(warn), type = 'warning')
      invokeRestart("muffleWarning")
      print('warning')
    })
  
  if(anyNA(epiestim_res_lit$check)){
    outcome <- epiestim_res_lit$R
    outcome$date <- (outcome$t_start + outcome$t_end) / 2 + date_st
    outcome$t_start <- date_st + outcome$t_start
    outcome$t_end <- date_st + outcome$t_end
    
    date_breaks <- values$date_breaks
    
    fig <- ggplot(data = outcome, mapping = aes(x = date)) +
      geom_ribbon(
        mapping = aes(
          ymin = `Quantile.0.025(R)`,
          ymax = `Quantile.0.975(R)`,
          fill = 'red'
        ),
        alpha = 0.3,
        show.legend = F
      ) +
      geom_line(
        mapping = aes(y = `Median(R)`, color = 'red'),
        size = 1,
        show.legend = F
      ) +
      geom_line(
        mapping = aes(y = 1),
        color = 'black',
        size = 1,
        linetype = "dashed",
        show.legend = F
      ) +
      # geom_text(mapping = aes(x = max(date)+1, y = 1, label = 'R[t]==1.0'), parse=T)+
      annotate(
        'text',
        x = max(outcome$date),
        y = 1,
        size = 12 / .pt,
        label = expression(R[t] == 1),
        hjust = 0,
        fontface = "bold"
      ) +
      scale_x_date(
        expand = c(0, 0),
        date_labels = "%m/%d",
        date_breaks = date_breaks
      ) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                         limits = c(0, NA)) +
      labs(x = "", y = expression(R[t])) +
      theme_set() +
      # theme(plot.margin=unit(c(1,3,1,1),'lines'))+
      coord_cartesian(clip = "off")
    
    figs$fig_Rt <- fig
    values$df_Rt <- outcome
    output$fig_EpiEstim_Rt <- renderPlot({
      fig
    })
  }
})

# uncertain si ------------------------------------------------------------

observeEvent(input$EpiEstim_uncertain_si_confirmed, {
  start_date  <- as.numeric(input$epiestim_uncertain_si_first)
  space_date  <- as.numeric(input$epiestim_uncertain_si_width)
  mean_si     <- input$epiestim_uncertain_si_mean_si
  std_mean_si <- input$epiestim_uncertain_si_std_mean_si
  min_mean_si <- input$epiestim_uncertain_si_min_mean_si
  max_mean_si <- input$epiestim_uncertain_si_max_mean_si
  std_si      <- input$epiestim_uncertain_si_std_si
  std_std_si  <- input$epiestim_uncertain_si_std_std_si
  min_std_si  <- input$epiestim_uncertain_si_min_std_si
  max_std_si  <- input$epiestim_uncertain_si_max_std_si
  n1          <- input$epiestim_uncertain_si_n1
  n2          <- input$epiestim_uncertain_si_n2
  
  if (is.na(mean_si) |
      is.na(std_si) |
      is.na(start_date) |
      is.na(space_date) | is.na(std_mean_si) | is.na(min_mean_si) |
      is.na(max_mean_si) |
      is.na(std_std_si) |
      is.na(min_std_si) | is.na(max_std_si) | is.na(n1) | is.na(n2)) {
    shinyalert(
      "提交失败",
      "原因：关键参数缺失！",
      timer = 5000 ,
      type = "error",
      size = 'xs'
    )
  } else{
    datafile <- values$df_global %>%
      group_by(t) %>%
      summarise(X = sum(X))
    names(datafile) <- c('dates', 'I')
    date_st <- min(datafile$dates)
    
    start_dates <- seq(start_date, nrow(datafile) - space_date)
    end_dates <- start_dates + space_date
    
    config_lit <- make_config(
      list(
        t_start     = start_dates,
        t_end       = end_dates,
        mean_si     = mean_si,
        std_mean_si = std_mean_si,
        min_mean_si = min_mean_si,
        max_mean_si = max_mean_si,
        std_si      = std_si,
        std_std_si  = std_std_si,
        min_std_si  = min_std_si,
        max_std_si  = max_std_si,
        n1          = n1,
        n2          = n2
      )
    )
    withCallingHandlers(
      tryCatch({
        epiestim_res_lit <- estimate_R(incid = datafile,
                                       method = "uncertain_si",
                                       config = config_lit)
        epiestim_res_lit$check <- NA
      },
      error = function(err) {
        showNotification(paste0(err), type = 'err')
        epiestim_res_lit$check <- 'ERROR'
      }),
      warning = function(warn) {
        showNotification(paste0(warn), type = 'warning')
        invokeRestart("muffleWarning")
      })
    if(anyNA(epiestim_res_lit$check)){
      outcome <- epiestim_res_lit$R
      outcome$date <-
        (outcome$t_start + outcome$t_end) / 2 + date_st
      outcome$t_start <- date_st + outcome$t_start
      outcome$t_end <- date_st + outcome$t_end
      
      date_breaks <- values$date_breaks
      
      fig <- ggplot(data = outcome, mapping = aes(x = date)) +
        geom_ribbon(
          mapping = aes(
            ymin = `Quantile.0.025(R)`,
            ymax = `Quantile.0.975(R)`,
            fill = 'red'
          ),
          alpha = 0.3,
          show.legend = F
        ) +
        geom_line(
          mapping = aes(y = `Median(R)`, color = 'red'),
          size = 1,
          show.legend = F
        ) +
        geom_line(
          mapping = aes(y = 1),
          color = 'black',
          size = 1,
          linetype = "dashed",
          show.legend = F
        ) +
        # geom_text(mapping = aes(x = max(date)+1, y = 1, label = 'R[t]==1.0'), parse=T)+
        annotate(
          'text',
          x = max(outcome$date),
          y = 1,
          size = 12 / .pt,
          label = expression(R[t] == 1),
          hjust = 0,
          fontface = "bold"
        ) +
        scale_x_date(
          expand = c(0, 0),
          date_labels = "%m/%d",
          date_breaks = date_breaks
        ) +
        scale_y_continuous(expand = expansion(mult = c(0, 0.1)),
                           limits = c(0, NA)) +
        labs(x = "", y = expression(R[t])) +
        theme_set() +
        # theme(plot.margin=unit(c(1,3,1,1),'lines'))+
        coord_cartesian(clip = "off")
      
      figs$fig_Rt <- fig
      values$df_Rt <- outcome
      output$fig_EpiEstim_Rt <- renderPlot({
        fig
      })
    }
  }
})

# R0 ----------------------------------------------------------------------

output$R0_gt_data_detail <- renderRHandsontable({
  DF <- data.frame("传染者发病时间" = rep(0, length(H1N1.serial.interval)),
                   "感染者发病时间" = H1N1.serial.interval)
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

observeEvent(input$R0_gt_data_confirmed, {
  if (input$R0_gt_input_type_2 == 'SI') {
    df <- hot_to_r(input$R0_gt_data_si)
    df <- df[rep(row.names(df), df$Freq), 1]
    df_gt <-
      suppressMessages(suppressWarnings(est.GT(serial.interval = as.numeric(df))))
    values$R0_gt <- df_gt
    output$R0_gt_data <- renderPrint(print(df_gt))
  }
  
  if (input$R0_gt_input_type_2 == 'detail') {
    df <- hot_to_r(input$R0_gt_data_detail)
    df_gt <- suppressMessages(suppressWarnings(
      est.GT(
        infector.onset.dates = df$传染者发病时间,
        infectee.onset.dates = df$感染者发病时间
      )
    ))
    values$R0_gt <- df_gt
    output$R0_gt_data <- renderPrint(print(df_gt))
  }
  
  if (input$R0_gt_input_type_2 == 'GT') {
    df <- input$R0_gt_data_gt_content
    df <- str_extract_all(df, "\\d+\\.*\\d*")[[1]]
    # df <- str_squish(df)
    if (length(df) != 0) {
      df_gt <- suppressMessages(suppressWarnings(
        generation.time(
          type = input$R0_gt_data_gt_type,
          val = as.numeric(df)
        )
      ))
      values$R0_gt <- df_gt
      output$R0_gt_data <- renderPrint(print(df_gt))
    } else {
      shinyalert(
        "提交失败",
        "原因：关键参数缺失！",
        timer = 5000 ,
        type = "error",
        size = 'xs'
      )
    }
  }
})

observeEvent(input$R0_gt_data_gt_example, {
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

observeEvent(input$R0_Rt_confirmed, {
  gt <- values$R0_gt
  if (length(gt) != 0) {
    df <- values$df_global %>%
      group_by(t) %>%
      summarise(X = sum(X))
    df_value <- df$X
    names(df_value) <- df$onset
    if (input$R0_Rt_est_function == 'TD') {
      df_Rt <- est.R0.TD(
        df_value,
        gt,
        begin = 1,
        end = as.numeric(length(df_value)),
        nsim = input$R0_TD_nsim
      )
      if (is.null(input$R0_Rt_smooth)) {
        df_Rt <- smooth.Rt(df_Rt, 7)
      }
      datafile <- data.frame(
        date = df_Rt$epid$t,
        Rt = df_Rt$R,
        Rt_lower = df_Rt$conf.int$lower,
        Rt_upper = df_Rt$conf.int$upper
      )
      datafile$date <- datafile$date + min(df$t) - 1
      values$df_Rt <- datafile
    }
    if (input$R0_Rt_est_function == 'SB') {
      df_Rt <- est.R0.SB(df$X, gt)
      datafile <- data.frame(
        date = seq.Date(
          from = df_Rt$begin + min(df$t) - 1,
          to = df_Rt$end - 1 + min(df$t) - 1,
          by = 'day'
        ),
        Rt = df_Rt$R,
        Rt_lower = df_Rt$conf.int$CI.lower.,
        Rt_upper = df_Rt$conf.int$CI.upper.
      )
      values$df_Rt <- datafile
    }
    
    output$R0_est_Rt <- renderPrint(print(df_Rt))
    browser()
    date_breaks <- values$date_breaks
    fig <- ggplot(data = datafile, mapping = aes(x = date)) +
      geom_ribbon(
        mapping = aes(
          ymin = Rt_lower,
          ymax = Rt_upper,
          fill = 'red'
        ),
        alpha = 0.3,
        show.legend = F
      ) +
      geom_line(
        mapping = aes(y = Rt, color = 'red'),
        size = 1,
        show.legend = F
      ) +
      geom_line(
        mapping = aes(y = 1),
        color = 'black',
        size = 1,
        linetype = "dashed",
        show.legend = F
      ) +
      # geom_text(mapping = aes(x = max(date)+1, y = 1, label = 'R[t]==1.0'), parse=T)+
      annotate(
        'text',
        x = max(datafile$date),
        y = 1,
        size = 12 / .pt,
        label = expression(R[t] == 1),
        hjust = 0,
        fontface = "bold"
      ) +
      scale_x_date(
        expand = c(0, 0),
        date_labels = "%m/%d",
        date_breaks = date_breaks
      ) +
      scale_y_continuous(expand = c(0, 0)) +
      labs(x = "", y = expression(R[t])) +
      theme_set() +
      # theme(plot.margin=unit(c(1,3,1,1),'lines'))+
      coord_cartesian(clip = "off")
    
    figs$fig_Rt <- fig
    
    output$fig_R0_Rt <- renderPlot({
      fig
    })
  } else {
    shinyalert(
      "提交失败",
      "原因：关键参数缺失！",
      timer = 5000 ,
      type = "error",
      size = 'xs'
    )}
})


# download button ---------------------------------------------------------

observeEvent(input$Rt_download, {
  if (!is.null(values$df_plot)) {
    showModal(
      modalDialog(
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_png",
            "下载结果(png)",
            icon = icon("file-image"),
            class = 'butt'
          )
        )),
        br(),
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_tiff",
            "下载结果(tiff)",
            icon = icon("file-image"),
            class = 'butt'
          )
        )),
        br(),
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_pdf",
            "下载结果(PDF)",
            icon = icon("file-pdf"),
            class = 'butt'
          )
        )),
        br(),
        fluidRow(column(
          width = 12,
          align = "center",
          downloadButton(
            "download_Rt_csv",
            "下载数据(csv)",
            icon = icon("file-excel"),
            class = 'butt'
          )
        )),
        title = "下载",
        size = "s",
        footer = list(modalButton("取消"))
      )
    )
    
    output$download_Rt_csv <- downloadHandler(
      filename = function() {
        paste0("Outcome", Sys.Date(), ".csv")
      },
      content = function(file) {
        write.csv(values$df_Rt, file, row.names = FALSE)
      }
    )
    
    output$download_Rt_png <- downloadHandler(
      filename = function() {
        paste0("Outcome", Sys.Date(), ".png")
      },
      content = function(file) {
        figs$fig_Rt
        ggsave(file, height = 7, width = 12)
      }
    )
    
    output$download_Rt_tiff <- downloadHandler(
      filename = function() {
        paste0("Outcome", Sys.Date(), ".tiff")
      },
      content = function(file) {
        figs$fig_Rt
        ggsave(file, height = 7, width = 12)
      }
    )
    
    output$download_Rt_pdf <- downloadHandler(
      filename = 'outcome.pdf',
      content = function(file) {
        pdf(file)
        print(figs$fig_Rt)
        dev.off()
      }
    )
    
  } else {
    showModal(modalDialog(
      fluidRow(column(
        width = 12,
        align = "center",
        h3('没找到数据, 请点击“数据预览”按钮并出现流行曲线后再试~')
      )),
      title = "Error",
      size = "s",
      footer = list(modalButton("确定"))
    ))
  }
})

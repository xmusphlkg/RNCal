function(input, output, session) {
  
  values <- reactiveValues(df_global = NULL,
                           df_plot = NULL,
                           R0_gt = NULL,
                           df_Rt = NULL,
                           date_breaks = NULL)
  figs <- reactiveValues(fig_epicurve = NULL,
                         fig_earlyR_R0 = NULL,
                         fig_R0_R0 = NULL,
                         fig_Rt = NULL)
  
  source('server/data_input.R', local = TRUE, encoding = 'UTF-8')
  source('server/basic_RN.R', local = TRUE, encoding = 'UTF-8')
  source('server/real_RN.R', local = TRUE, encoding = 'UTF-8')
  source('server/massage.R', local = TRUE, encoding = 'UTF-8')
  
  observeEvent(input$Tab_dataload, {
    if(is.null(input$data_raw)){
      insertTab(inputId = "tabs",
                tabPanel(title = 'Step1: 数据输入', data_input, value = "Data_input"),
                target = 'Notice',
                select = T)
    }
  })
  
  observeEvent(input$Tab_R0, {
    if(is.null(input$select_packages_R0)){
      insertTab(inputId = "tabs",
                tabPanel(title = 'Step2: 基本再生数计算', basic_RN, value = "Basic_RN"),
                target = 'Data_input',
                select = T)
    } else {
      updateNavbarPage(
        session,
        inputId = 'tabs',
        selected = 'Basic_RN'
      )
    }
  })
  
  observeEvent(input$Tab_R0_1, {
    if(is.null(values$df_plot)){
         shinyalert("提交失败", "请点击'预览'后重试！", 
                    timer = 5000 , 
                    type = "error",
                    size = 'xs')
    } else {
         if(is.null(input$select_packages_R0)){
              insertTab(inputId = "tabs",
                        tabPanel(title = 'Step2: 基本再生数计算', basic_RN, value = "Basic_RN"),
                        target = 'Data_input',
                        select = T)
         } else {
              updateNavbarPage(
                   session,
                   inputId = 'tabs',
                   selected = 'Basic_RN'
              )
         }
    }
  })
  
  observeEvent(input$Tab_Rt, {
    if(is.null(input$select_packages)){
      if(is.null(input$select_packages_R0)){
        insertTab(inputId = "tabs",
                  tabPanel(title = 'Step3: 实时再生数计算', real_RN, value = 'Real_RN'),
                  target = 'Data_input',
                  select = T)
      } else {
        insertTab(inputId = "tabs",
                  tabPanel(title = 'Step3: 实时再生数计算', real_RN, value = 'Real_RN'),
                  target = 'Basic_RN',
                  select = T)
      }
    } else {
      updateNavbarPage(
        session,
        inputId = 'tabs',
        selected = 'Real_RN'
      )
    }
  })
  
  observeEvent(input$Tab_Rt_1, {
    if(is.null(values$df_plot)){
         shinyalert("提交失败", "请点击'预览'后重试！", 
                    timer = 5000 , 
                    type = "error",
                    size = 'xs')
    } else {
         if(is.null(input$select_packages)){
              if(is.null(input$select_packages_R0)){
                   insertTab(inputId = "tabs",
                             tabPanel(title = 'Step3: 实时再生数计算', real_RN, value = 'Real_RN'),
                             target = 'Data_input',
                             select = T)
              } else {
                   insertTab(inputId = "tabs",
                             tabPanel(title = 'Step3: 实时再生数计算', real_RN, value = 'Real_RN'),
                             target = 'Basic_RN',
                             select = T)
              }
         } else {
              updateNavbarPage(
                   session,
                   inputId = 'tabs',
                   selected = 'Real_RN'
              )
         }
    }
  })
  
  output$download_Rt_pdf <- downloadHandler(
       filename = 'outcome.pdf',
       content = function(file) {
            pdf(file)
            print(figs$fig_Rt)
            dev.off()
       }
  )
  
}
basic_RN <- tabPanelBody(
  value = "Basic_RN",
  box(
    title = "参数设置",
    status = 'warning',
    width = 12,
    column(
      width = 2,
      align = "center",
      pickerInput(
        inputId = "select_packages_R0",
        label = "选择估计方法 (Packages)",
        choices = c('EarlyR', 'R0'),
        selected = 'EarlyR',
        options = list(style = "btn-danger")
      ),
      # actionBttn(
      #   inputId = 'confirmed_packages_R0',
      #   label = '确认',
      #   color = 'danger',
      #   style = 'float',
      #   icon = icon('power-off')
      # ),
      actionBttn(
        inputId = 'Tab_Rt',
        label = '转到Rt计算',
        style = 'float',
        icon = icon('toggle-off'),
        color = 'success'
      ),
      tags$style(type = 'text/css', "#confirmed_packages { vertical-align: middle;}")
    ),
    column(
      width = 10,
      # earlyR ---------------------------------------------------------------
      conditionalPanel(condition = "input.select_packages_R0 == 'EarlyR'",
                       fluidRow(box(
                         width = 12,
                         status = 'success',
                         column(
                           width = 8,
                           column(
                             width = 12,
                             pickerInput(
                               inputId = 'earlyR_si_data',
                               label = '默认数据',
                               choices = c(
                                 "Delta_广东" = '3.4-2.3',
                                 "Delta_01" = '4.4-3.3',
                                 "Delta_02" = '5.4-4.3',
                                 "Delta_03" = '3.4-2.3',
                                 "Delta_04" = '3.4-2.3',
                                 'NULL'
                               ),
                               selected = 'NULL',
                               width = '100%'
                             )
                           ),
                           column(
                             width = 3,
                             numericInput(
                               inputId = 'earlyR_si_mean',
                               label = '代间距(SI)均数',
                               width = '100%',
                               value = 2.3
                             )
                           ),
                           column(
                             width = 3,
                             numericInput(
                               inputId = 'earlyR_si_std',
                               label = '代间距(SI)标准差',
                               width = '100%',
                               value = 3.4
                             )
                           ),
                           column(
                             width = 3,
                             numericInput(
                               inputId = 'earlyR_max_R',
                               label = '最大再生数(可选)',
                               width = '100%',
                               value = NA
                             )
                           ),
                           div(column(
                             width = 3,
                             align = "center",
                             actionBttn(
                               inputId = 'earlyR_si_confirmed',
                               label = '估计R0',
                               color = 'danger',
                               style = 'float'
                             )
                           ),
                           style = 'top: 25px;position: relative;')
                         )
                       ))),
      # R0 -------------------------------------------------------------------
      conditionalPanel(condition = "input.select_packages_R0 == 'R0'",
                       fluidRow(
                         box(
                           width = 12,
                           title = '此处估计Rt应使用GT，而非SI，注意转换',
                           status = 'danger',
                           column(
                             width = 8,
                             column(
                               width = 9,
                               pickerInput(
                                 inputId = 'R0_gt_input_type_1',
                                 label = '选择数据类型',
                                 choices = c(
                                   "Serial Interval" = "SI",
                                   "详细数据" = "detail",
                                   "Generation Time" = "GT"
                                 ),
                                 selected = 'SI'
                               )
                             ),
                             div(column(
                               width = 3,
                               align = "center",
                               actionBttn(
                                 inputId = 'R0_gt_data_confirmed_1',
                                 label = '生成GT',
                                 color = 'danger',
                                 style = 'float'
                               )
                             ),
                             style = 'top: 25px;position: relative;'),
                             column(width = 12,
                                    verbatimTextOutput('R0_gt_data_1', placeholder = T),),
                             column(
                               width = 3,
                               pickerInput(
                                 inputId = 'R0_est_function',
                                 label = '方法选择',
                                 choices = c(
                                   'exponential growth rate' = 'EG',
                                   'maximum likelihood' = 'ML'
                                 ),
                                 selected = 'maximum likelihood'
                               )
                             ),
                             column(
                               width = 3,
                               numericInput(
                                 inputId = 'R0_est_begin',
                                 label = '开始时间',
                                 value = 1,
                                 min = 1,
                                 width = '100%'
                               )
                             ),
                             column(
                               width = 3,
                               numericInput(
                                 inputId = 'R0_est_end',
                                 label = '结束时间',
                                 value = 7,
                                 min = 3,
                                 width = '100%'
                               )
                             ),
                             div(column(
                               width = 3,
                               align = "center",
                               actionBttn(
                                 inputId = 'R0_R0_confirmed',
                                 label = '估计R0',
                                 color = 'danger',
                                 style = 'float'
                               )
                             ),
                             style = 'top: 25px;position: relative;')
                           ),
                           conditionalPanel(condition = 'input.R0_gt_input_type_1 == "SI"',
                                            column(
                                              width = 4,
                                              rHandsontableOutput("R0_gt_data_si_1", height = '250px')
                                            )),
                           conditionalPanel(condition = 'input.R0_gt_input_type_1 == "detail"',
                                            column(
                                              width = 4,
                                              rHandsontableOutput("R0_gt_data_detail_1", height = '250px')
                                            )),
                           conditionalPanel(
                             condition = 'input.R0_gt_input_type_1 == "GT"',
                             column(
                               width = 2,
                               pickerInput(
                                 inputId = 'R0_gt_data_gt_type_1',
                                 label = 'GT分布',
                                 choices = c("empirical", "gamma", "weibull", "lognormal"),
                                 selected = 'gamma'
                               )
                             ),
                             column(
                               width = 2,
                               actionButton(inputId = 'R0_gt_data_gt_example_1',
                                            label = '示例'),
                               style = 'top: 25px;position: relative;'
                             ),
                             column(
                               width = 4,
                               textAreaInput(
                                 inputId = 'R0_gt_data_gt_content_1',
                                 label = 'values(使用半角的 , 分割)',
                                 width = '100%',
                                 height = '200px'
                               )
                             )
                             
                           )
                         )
                       ))
      # end ------------------------------------------------------------------
    ),
  ),
  box(
    title = "结果",
    conditionalPanel(condition = "input.select_packages_R0 == 'EarlyR'",
                     plotOutput('fig_earlyR_R0'),
                     # column(
                     #   width = 12,
                     #   align = 'right',
                     #   actionBttn(
                     #     inputId = 'R0_earlyR_download',
                     #     label = '结果下载',
                     #     size = 'sm',
                     #     color = 'warning',
                     #     icon = icon("download"),
                     #   )
                     # )),
                     conditionalPanel(
                       condition = "input.select_packages_R0 == 'R0'",
                       column(
                         width = 12,
                         verbatimTextOutput('R0_est_R0', placeholder = T),
                         plotOutput('fig_R0_R0')
                       )
                     )
    )
  )
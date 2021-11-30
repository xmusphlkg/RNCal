real_RN <- tabPanelBody(
  value = "Real_RN",
  tags$head(tags$style(".butt{background-color:#E95420; color: white; width: 100%}")),
  box(title = "参数设置",
      status = 'warning',
      width = 12,
      column(
        width = 2,
        align="center",
        pickerInput(
          inputId = "select_packages",
          label = "选择估计方法 (Packages)", 
          # choices = c('EpiEstim', 'R0', 'EpiNow2'),
          choices = c('EpiEstim', 'R0'),
          selected = 'EpiEstim',
          options = list(style = "btn-danger")
        ),
        # actionBttn(
        #   inputId = 'confirmed_packages',
        #   label = '计算Rt',
        #   color = 'danger',
        #   size = 'lg',
        #   style = 'float',
        #   icon = icon('power-off')
        # ),
        actionBttn(
          inputId = 'Tab_R0',
          label = '转到R0计算',
          icon = icon('toggle-off'),
          color = 'success'
        ),
        tags$style(type='text/css', "#confirmed_packages { vertical-align: middle;}")
      ),
      column(
        width = 10,
        
        # EpiEstim ----------------------------------------------------------------
        conditionalPanel(condition = "input.select_packages == 'EpiEstim'",
                         fluidRow(
                           box(width = 12,
                               status = 'primary',
                               column(
                                 width = 6,
                                 pickerInput(
                                   inputId = 'epiestim_method',
                                   label = '方法设置',
                                   choices = c("non_parametric_si", "parametric_si", "uncertain_si", "si_from_data",
                                               "si_from_sample"),
                                   selected = 'parametric_si'
                                 ),
                                 conditionalPanel(condition = 'input.epiestim_method == "parametric_si"',
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_parametric_si_data',
                                                      label = '默认数据',
                                                      choices = c("Delta_广东", 
                                                                  "Delta_01", 
                                                                  "Delta_02", 
                                                                  "Delta_03",
                                                                  "Delta_04"),
                                                      selected = 'Delta_广东'
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_parametric_si_std',
                                                      label = '代间距(SI)标准差',
                                                      width = '100%',
                                                      value = 3.4
                                                    ),
                                                    pickerInput(
                                                      inputId = 'epiestim_parametric_si_first',
                                                      label = '从第几天开始计算？',
                                                      choices = 2:30,
                                                      selected = 3
                                                    )
                                                    ),
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_parametric_si_width',
                                                      label = '计算间距(天)',
                                                      choices = 4:30,
                                                      selected = 7
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_parametric_si_mean',
                                                      label = '代间距(SI)均数',
                                                      width = '100%',
                                                      value = 2.3
                                                    ),
                                                    div(
                                                      column(
                                                        width = 12,
                                                        align="center",
                                                        actionBttn(
                                                          inputId = 'EpiEstim_rt_confirmed',
                                                          label = '估计Rt',
                                                          color = 'danger',
                                                          style = 'float'
                                                        )
                                                      ),
                                                      style = 'top: 25px;position: relative;'
                                                    )
                                                  )
                                 ),
                                 conditionalPanel(condition = 'input.epiestim_method == "non_parametric_si"',
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_non_parametric_si_data',
                                                      label = '默认数据',
                                                      choices = c("Delta_广东" = '3.4-2.3', 
                                                                  "Delta_01" = '3.4-2.3', 
                                                                  "Delta_02" = '3.4-2.3', 
                                                                  "Delta_03" = '3.4-2.3',
                                                                  "Delta_04" = '3.4-2.3'),
                                                      selected = 'Delta_广东'
                                                    )),
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_non_parametric_si_width',
                                                      label = '计算间距(天)',
                                                      choices = 3:30,
                                                      selected = 7
                                                    )
                                                  ),
                                                  column(
                                                    width = 12,
                                                    rHandsontableOutput('non_parametric_si_data')
                                                  )
                                 ),
                                 conditionalPanel(condition = 'input.epiestim_method == "uncertain_si"',
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_uncertian_si_data',
                                                      label = '默认数据',
                                                      choices = c("Delta_广东" = '3.4-2.3', 
                                                                  "Delta_01" = '3.4-2.3', 
                                                                  "Delta_02" = '3.4-2.3', 
                                                                  "Delta_03" = '3.4-2.3',
                                                                  "Delta_04" = '3.4-2.3'),
                                                      selected = 'Delta_广东'
                                                    )),
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_uncertain_si_width',
                                                      label = '计算间距(天)',
                                                      choices = 3:30,
                                                      selected = 7
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_mean',
                                                      label = '代间距(SI)均数',
                                                      width = '100%',
                                                      value = 2.6
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_mean_min',
                                                      label = '代间距(SI)均数最小值',
                                                      width = '100%',
                                                      value = 1
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_mean_max',
                                                      label = '代间距(SI)均数最大值',
                                                      width = '100%',
                                                      value = 4.2
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_mean_std',
                                                      label = '代间距(SI)均数标准差',
                                                      width = '100%',
                                                      value = 1
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_n1',
                                                      label = 'n1',
                                                      width = '100%',
                                                      value = 100
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_std',
                                                      label = '代间距(SI)标准差',
                                                      width = '100%',
                                                      value = 1.5
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_std_std',
                                                      label = '代间距(SI)标准差的标准差',
                                                      width = '100%',
                                                      value = 0.5
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_std_min',
                                                      label = '代间距(SI)标准差最小值',
                                                      width = '100%',
                                                      value = 0.5
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_std_max',
                                                      label = '代间距(SI)标准差最大值',
                                                      width = '100%',
                                                      value = 2.5
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_uncertain_si_n2',
                                                      label = 'n2',
                                                      width = '100%',
                                                      value = 100
                                                    )
                                                  )
                                 ),
                                 conditionalPanel(condition = 'input.epiestim_method == "si_from_sample"',
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_si_from_sample_data',
                                                      label = '默认数据',
                                                      choices = c("Delta_广东" = '3.4-2.3', 
                                                                  "Delta_01" = '3.4-2.3', 
                                                                  "Delta_02" = '3.4-2.3', 
                                                                  "Delta_03" = '3.4-2.3',
                                                                  "Delta_04" = '3.4-2.3'),
                                                      selected = 'Delta_广东'
                                                    )),
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_si_from_sample_width',
                                                      label = '计算间距(天)',
                                                      choices = 3:30,
                                                      selected = 7
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_sample_mcmc_seed',
                                                      label = 'MCMC seed',
                                                      width = '100%',
                                                      value = 100
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_sample_overall_seed',
                                                      label = 'overall seed',
                                                      width = '100%',
                                                      value = 100
                                                    ),
                                                    selectInput(
                                                      inputId = 'epiestim_si_from_sample_dist',
                                                      label = 'distribution',
                                                      width = '100%',
                                                      choices = c('Gamma' = 'G',
                                                                  'log-normal' = 'L',
                                                                  'weibull' = 'W',
                                                                  'erlang' = 'E'),
                                                      selected = 'Gamma'
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_sample_n2',
                                                      label = 'n2',
                                                      width = '100%',
                                                      value = 50
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_sample_burnin',
                                                      label = 'burnin',
                                                      width = '100%',
                                                      value = 1000
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_sample_n.samples',
                                                      label = 'n.sample',
                                                      width = '100%',
                                                      value = 5000
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_sample_thin',
                                                      label = 'thin',
                                                      width = '100%',
                                                      value = 10
                                                    )
                                                  )
                                 ),
                                 conditionalPanel(condition = 'input.epiestim_method == "si_from_data"',
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_si_from_data_data',
                                                      label = '默认数据',
                                                      choices = c("Delta_广东" = '3.4-2.3', 
                                                                  "Delta_01" = '3.4-2.3', 
                                                                  "Delta_02" = '3.4-2.3', 
                                                                  "Delta_03" = '3.4-2.3',
                                                                  "Delta_04" = '3.4-2.3'),
                                                      selected = 'Delta_广东'
                                                    )),
                                                  column(
                                                    width = 6,
                                                    pickerInput(
                                                      inputId = 'epiestim_si_from_data_width',
                                                      label = '计算间距(天)',
                                                      choices = 3:30,
                                                      selected = 7
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_data_mcmc_seed',
                                                      label = 'MCMC seed',
                                                      width = '100%',
                                                      value = 100
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_data_overall_seed',
                                                      label = 'overall seed',
                                                      width = '100%',
                                                      value = 100
                                                    ),
                                                    selectInput(
                                                      inputId = 'epiestim_si_from_data_dist',
                                                      label = 'distribution',
                                                      width = '100%',
                                                      choices = c('Gamma' = 'G',
                                                                  'log-normal' = 'L',
                                                                  'weibull' = 'W',
                                                                  'erlang' = 'E'),
                                                      selected = 'Gamma'
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_data_n1',
                                                      label = 'n1',
                                                      width = '100%',
                                                      value = 50
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_data_burnin',
                                                      label = 'burnin',
                                                      width = '100%',
                                                      value = 1000
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_data_thin',
                                                      label = 'n.sample',
                                                      width = '100%',
                                                      value = 10
                                                    ),
                                                    numericInput(
                                                      inputId = 'epiestim_si_from_data_n1',
                                                      label = 'thin',
                                                      width = '100%',
                                                      value = 500
                                                    )
                                                  )
                                 )
                               ), ## left
                               conditionalPanel(condition = 'input.epiestim_method == "si_from_sample"',
                                                column(
                                                  width = 6,
                                                  rHandsontableOutput('non_si_from_sample_data')
                                                )),
                               conditionalPanel(condition = 'input.epiestim_method == "si_from_data"',
                                                column(
                                                  width = 6,
                                                  rHandsontableOutput('non_si_from_data_data')
                                                )
                                                )
                               
                           )
                         )
                         ),
        
        # EpiNow2 --------------------------------------------------------------
        conditionalPanel(condition = "input.select_packages == 'EpiNow2'",
                         fluidRow(
                           box(
                             width = 12,
                             status = 'info',
                             column(
                               width = 6,
                               column(
                                 width = 3,
                                 pickerInput(
                                   inputId = 'EpiNow2_data_input_type',
                                   label = '数据类型',
                                   choices = c("发病数据" = "onset", 
                                               "报告数据" = "report"),
                                   selected = '发病数据'
                                 )
                               ),
                               column(
                                 width = 9,
                                 column(
                                   width = 12,
                                   column(
                                     width = 6,
                                     pickerInput(
                                       inputId = 'EpiNow2_incubation_period_type',
                                       label = '潜伏期计算方式',
                                       choices = c("拟合" = "fit", 
                                                   "输入" = "input",
                                                   '示例' = "example"),
                                       selected = 'example'
                                     )
                                   ),
                                   div(
                                     column(
                                       width = 6,
                                       align="center",
                                       actionBttn(
                                         inputId = 'EpiNow2_incubation_period_confirmed',
                                         label = '计算潜伏期',
                                         size = 'sm',
                                         color = 'danger',
                                         style = 'float',
                                       )
                                     ),
                                     style = 'top: 25px;position: relative;'
                                   )
                                 ),
                                 column(
                                   width = 12,
                                   column(
                                     width = 6,
                                     pickerInput(
                                       inputId = 'EpiNow2_gt_input_type',
                                       label = '代间距类型',
                                       choices = c("Serial Interval" = "SI", 
                                                   "详细数据" = "detail", 
                                                   "Generation Time" = "GT",
                                                   '示例' = "example"),
                                       selected = 'example'
                                     )
                                   ),
                                   div(
                                     column(
                                       width = 6,
                                       align="center",
                                       actionBttn(
                                         inputId = 'EpiNow2_gt_confirmed',
                                         label = '计算代间距',
                                         size = 'sm',
                                         color = 'danger',
                                         style = 'float',
                                       )
                                     ),
                                     style = 'top: 25px;position: relative;'
                                   )
                                 )
                               )
                             ),
                             #### incubation panel -------
                             tabBox(
                               side = 'left',
                               height = '400px',
                               width = 6,
                               tabPanel(
                                 "潜伏期设置",
                                 conditionalPanel(condition = 'input.EpiNow2_incubation_period_type == "input"',
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'input.EpiNow2_incubation_mean',
                                                      label = '潜伏期均数',
                                                      value = 9.1,
                                                      min = 0.1
                                                    ),
                                                    numericInput(
                                                      inputId = 'input.EpiNow2_incubation_mean_sd',
                                                      label = '潜伏期均数方差',
                                                      value = 0.1,
                                                      min = 0.01
                                                    ),
                                                    numericInput(
                                                      inputId = 'input.EpiNow2_incubation_max',
                                                      label = '潜伏期最大值',
                                                      value = 30,
                                                      min = 1
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'input.EpiNow2_incubation_sd',
                                                      label = '潜伏期方差',
                                                      value = 7.3,
                                                      min = 0.1
                                                    ),
                                                    numericInput(
                                                      inputId = 'input.EpiNow2_incubation_sd_sd',
                                                      label = '潜伏期方差方差',
                                                      value = 0.1,
                                                      min = 0.01
                                                    )
                                                  )),
                                 conditionalPanel(condition = 'input.EpiNow2_incubation_period_type == "fit"',
                                                  column(
                                                    width = 5,
                                                    numericInput(
                                                      inputId = 'input.EpiNow2_incubation_max',
                                                      label = '潜伏期最大值',
                                                      value = 30,
                                                      min = 1
                                                    ),
                                                    pickerInput(
                                                      inputId = 'input.EpiNow2_incubation_dist',
                                                      label = "潜伏期分布",
                                                      choices = c("正态" = "lognormal", 
                                                                  "Gamma" = "gamma"),
                                                      selected = '正态'
                                                    )
                                                  ),
                                                  column(
                                                    width = 7,
                                                    rHandsontableOutput('EpiNow2_incubation_data', height = '250px')
                                                  ))
                               ),
                               #### GT tabpanel ---------
                               tabPanel(
                                 "代间距(GT)设置",
                                 conditionalPanel(condition = 'input.EpiNow2_gt_input_type == "GT"',
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'EpiNow2_gt_input_mean',
                                                      label = '代间距均数',
                                                      value = 3.64,
                                                      min = 0.1
                                                    ),
                                                    numericInput(
                                                      inputId = 'EpiNow2_gt_input_mean_sd',
                                                      label = '代间距均数方差',
                                                      value = 0.71,
                                                      min = 0.01
                                                    ),
                                                    numericInput(
                                                      inputId = 'EpiNow2_gt_input_max',
                                                      label = '代间距最大值',
                                                      value = 15,
                                                      min = 1
                                                    )
                                                  ),
                                                  column(
                                                    width = 6,
                                                    numericInput(
                                                      inputId = 'EpiNow2_gt_input_sd',
                                                      label = '代间距方差',
                                                      value = 3.08,
                                                      min = 0.1
                                                    ),
                                                    numericInput(
                                                      inputId = 'EpiNow2_gt_input_sd_sd',
                                                      label = '代间距方差方差',
                                                      value = 0.77,
                                                      min = 0.01
                                                    )
                                                  ))
                               )
                               #### end --------
                             ),
                             
                           )
                         )),
        # R0 -------------------------------------------------------------------
        conditionalPanel(condition = "input.select_packages == 'R0'",
                         fluidRow(
                           box(
                             title = '此处估计Rt应使用GT，而非SI，注意转换',
                             width = 12,
                             status = 'danger',
                             column(
                               width = 8,
                               column(
                                 width = 9,
                                 pickerInput(
                                   inputId = 'R0_gt_input_type_2',
                                   label = '选择数据类型',
                                   choices = c("Serial Interval" = "SI", 
                                               "详细数据" = "detail", 
                                               "Generation Time" = "GT"),
                                   selected = 'SI'
                                 )
                               ),
                               div(
                                 column(
                                   width = 3,
                                   align="center",
                                   actionBttn(
                                     inputId = 'R0_gt_data_confirmed',
                                     label = '生成GT',
                                     color = 'danger',
                                     style = 'float'
                                   )
                                 ),
                                 style = 'top: 25px;position: relative;'
                               ),
                               column(
                                 width = 12,
                                 verbatimTextOutput('R0_gt_data', placeholder = T),
                               ),
                               column(
                                 width = 3,
                                 pickerInput(
                                   inputId = 'R0_Rt_est_function',
                                   label = '方法选择',
                                   choices = c('Wallinga & Teunis' = "TD",
                                               'Bayesian approach' = "SB"),
                                   selected = 'Wallinga & Teunis'
                                 )
                               ),
                               conditionalPanel(condition = 'input.R0_Rt_est_function == "TD"',
                                            column(
                                              width = 3,
                                              numericInput(
                                                inputId = 'R0_TD_nsim',
                                                label = '模拟次数',
                                                value = 100,
                                                width = '100%'
                                              )
                                            ),
                                            column(
                                              width = 3,
                                              numericInput(
                                                inputId = 'R0_Rt_smooth',
                                                label = 'Rt平滑间隔(天)',
                                                value = 7,
                                                min = 2,
                                                width = '100%'
                                              )
                                            )),
                               div(
                                 column(
                                   width = 3,
                                   align="center",
                                   actionBttn(
                                     inputId = 'R0_Rt_confirmed',
                                     label = '估计Rt',
                                     color = 'danger',
                                     style = 'float'
                                   )
                                 ),
                                 style = 'top: 25px;position: relative;'
                               )
                             ),
                             conditionalPanel(condition = 'input.R0_gt_input_type_2 == "SI"',
                                              column(
                                                width = 4,
                                                rHandsontableOutput("R0_gt_data_si", height = '250px')
                                              )
                             ),
                             conditionalPanel(condition = 'input.R0_gt_input_type_2 == "detail"',
                                              column(
                                                width = 4,
                                                rHandsontableOutput("R0_gt_data_detail", height = '250px')
                                              )
                             ),
                             conditionalPanel(condition = 'input.R0_gt_input_type_2 == "GT"',
                                              column(
                                                width = 2,
                                                pickerInput(
                                                  inputId = 'R0_gt_data_gt_type',
                                                  label = 'GT分布',
                                                  choices = c("empirical", "gamma", "weibull", "lognormal"),
                                                  selected = 'gamma'
                                                )),
                                              column(
                                                width = 2,
                                                actionButton(
                                                  inputId = 'R0_gt_data_gt_example',
                                                  label = '示例'
                                                ),
                                                style = 'top: 25px;position: relative;'
                                                ),
                                              column(
                                                width = 4,
                                                textAreaInput(
                                                  inputId = 'R0_gt_data_gt_content',
                                                  label = 'values(使用半角的 , 分割)',
                                                  width = '100%',
                                                  height = '200px'
                                                )
                                              )
                                              
                             )
                           )
                         ))
        # end ------------------------------------------------------------------
      )
      ),
  # outcome --------------------------------------------------------------------
  box(title = "结果",
      conditionalPanel(condition = "input.select_packages == 'EpiEstim'",
                       plotOutput('fig_earlyR_R0')
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
                       # )
      ),
      conditionalPanel(condition = "input.select_packages == 'R0'",
                       column(
                         width = 12,
                         verbatimTextOutput('R0_est_R0', placeholder = T),
                         plotOutput('fig_R0_R0')
                       )))
)
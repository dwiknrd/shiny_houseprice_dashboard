shinyServer(function(input, output) {
  
  output$n_rumah <- renderValueBox({
    
    valueBox(value = prettyNum(sum(properti$Tipe.Properti == "Rumah"), big.mark='.'), 
             subtitle = "Data Properti Rumah", 
             color = "purple",
             icon = icon("house")
             )
    
  })
  
  output$n_apart <- renderValueBox({
    
    valueBox(value = prettyNum(sum(properti$Tipe.Properti == "Apartemen"), big.mark='.'), 
             subtitle = "Data Properti Apartemen", 
             color = "purple",
             icon = icon("building"))
    
  })
  
  output$plot1 <- renderPlotly({
    
    plot1 <- ggplot(properti_rumah, aes(x = Price,
                                        text = glue("Harga {scales::dollar_format(prefix = 'Rp ', suffix = ' jt', scale = 1e-6)(properti_rumah$Price)}"))) + 
      geom_histogram(fill = palet_warna[4], alpha = 0.9, bins = 10) +
      labs(
        title = "Distribusi Harga Rumah Daerah Jabodetabek",
        x = "Harga Rumah",
        y = "Frekuensi"
      ) +
      scale_x_continuous(labels = scales::label_number(prefix = "Rp ", suffix = " jt", scale = 1e-6, big.mark = ".", decimal.mark = ",")) +
      theme_minimal()
    
    
    ggplotly(plot1, tooltip = "text")
    
    
  })
  
  output$plot2 <- renderPlotly({
    
    data_agg <- properti_rumah %>%
      count(Kota) %>%
      arrange(desc(n))
    
    # Barplot horizontal dengan pengurutan
    plot2 <- ggplot(data_agg, aes(x = n, y = reorder(Kota, n), fill = Kota,
                                  text = glue("Kota {Kota}, sebanyak {n} data"))) +
      geom_col(aes(fill = n), show.legend = FALSE, alpha = 0.9) +
      labs(
        title = "Jumlah Data Harga Rumah Per-Kota",
        subtitle = "Di Daerah JABODETABEK",
        x = "Jumlah Data",
        y = "Kota"
      ) +
      scale_fill_gradient(low = "#bc5090", high = "#58508d") +
      theme_minimal()
    
    ggplotly(plot2, tooltip = "text")
    
  })
  
  output$plot3 <- renderPlotly({
    
    plot3 <- ggplot(properti_rumah, aes(x = L.Bangunan, y = Price,
                                        text = glue("<b>{properti_rumah$Kota}</b>
                                                ------------------------- 
                                                Luas    : {L.Bangunan} m2
                                                Harga  : {scales::dollar_format(prefix = 'Rp ',
                                                suffix = ' jt',
                                                scale = 1e-6,
                                                big.mark = '.')(Price)}
                                                {properti_rumah$K.Tidur} Kamar Tidur |  {properti_rumah$K.Mandi} Kamar Mandi"))) +
      geom_point(aes(col=Kota), alpha=0.8) +
      scale_color_manual(values = palet_warna) + 
      labs(
        title = "Hubungan Luas Bangunan dan Harga"
      ) +
      geom_smooth(method = "lm", se = TRUE, color = "#ff6361", level=0.99) +
      scale_y_continuous(labels = scales::label_number(prefix = "Rp ", suffix = " jt", scale = 1e-6, big.mark = ".", decimal.mark = ",")) +
      labs(
        title = "Hubungan Luas dan Harga Bangunan",
        subtitle = "Di Daerah JABODETABEK",
        x = "Luas Bangunan (m2)",
        y = F
      ) +
      theme_minimal()
    ggplotly(plot3, tooltip = "text")
    
  })
  
  test_data <- eventReactive(input$action,{
    
    data_input <- data.frame(
                             K.Mandi = input$KAMAR_MANDI,
                             K.Tidur = input$KAMAR_TIDUR,
                             L.Bangunan = input$LUAS_BANGUNAN,
                             Sertifikat = input$SERTIFIKAT,
                             Kota = input$KOTA)
    
    data_predict <- data_input %>% mutate_at(c("K.Mandi", "K.Tidur", "L.Bangunan"), as.numeric)
    
    
  })
  
  prediction <- eventReactive(input$action,{
    
    model <- readRDS("model_all.RDS")
    
    pred <- predict(model, test_data())
    
    pred
    
  })
  
  output$hasil_prediksi <- renderValueBox({
    
    valueBox(value = dollar_format(prefix = 'Rp ', big.mark = ".", suffix = "")(prediction()), 
             subtitle = " ", 
             color = "purple")
    
  })
  
})
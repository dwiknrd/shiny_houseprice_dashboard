header <- dashboardHeader(
  title = "Prediksi Harga Rumah"
)

# ----Sidebar----

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      text = "Overview", 
      tabName = "page1",
      badgeLabel = "Deskripsi", 
      badgeColor = "teal",
      icon = icon("dashboard")
    ),
    menuItem(
      text = "Prediction Tool", 
      tabName = "page2",
      badgeLabel = "Prediksi", 
      badgeColor = "fuchsia",
      icon = icon("gears")
    )
  )
)

# Dashboard Body

body <- dashboardBody(
  ## ----STYLE----
  tags$style(HTML("
                  /* Palet Warna */
                  $purple: #58508d;
                  $pink: #bc5090;
                  $orange: #ff6361;
                  $yellow: #ffa600;
                  
                  .box.box-primary {
                    border-top-color: $purple;
                  }

                  .box.box-solid.box-primary>.box-header {
                    color: #ffffff;
                    background: #ffffff;
                  }

                  .box.box-solid.box-primary {
                    border-bottom-color: #ffffff;
                    border-left-color: #ffffff;
                    border-right-color: #ffffff;
                    border-top-color: $yellow;
                    background: #ffffff;
                  }

                  .btn-primary {
                    background-color: $purple;
                    border-color: #2e6da4;
                  }

                  .irs--shiny .irs-bar {
                    border-top: 1px solid $purple;
                    border-bottom: 1px solid $purple;
                    background: $purple;
                  }

                  .irs--shiny .irs-single {
                    background-color: $purple;
                  }

                  .box-header.with-border {
                    text-align: center;
                    background: $yellow;
                  }

                  .form-control {
                    text-align: center;
                  }

                  pre.shiny-text-output {
                    text-align: center;
                  }

                  .box-body {
                    background: $yellow;
                  }

                  code, kbd, pre, samp {
                    font-family: arial;
                    font-size: 18px;
                    font-weight: bold;
                    font-style: italic;
                  }

                  pre {
                    background-color: #FFFFFF;
                  }

                  .main-footer {
                    background: #ecf0f5;
                    border-top: 1px #ecf0f;
                  }

                    ")),
  
  ## ----PAGE 1----
  tabItems(
    tabItem(
      tabName = "page1",
      
      fluidRow(
        box(
          title = "Dashboard Data Harga Rumah",
          closable = TRUE, 
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          collapsible = TRUE,
          width = 12,
          p("Selamat datang di Dashboard Interaktif Prediksi Harga Rumah JABODETABEK!
            Temukan visualisasi menarik tentang harga rumah di berbagai kota. 
            Eksplorasi hubungan faktor-faktor seperti luas bangunan, jumlah kamar tidur, dan kota dengan harga properti. 
            Mulai jelajahi dan dapatkan pemahaman instan tentang tren pasar properti di wilayah ini!")
        )
        
      ),
      ### ---- baris 2----
      fluidRow(
        
        box(
          title = "Informasi Umum",
          collapsible = TRUE,
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          width = 12,
          
          
          
          valueBoxOutput(
            outputId = "n_rumah", 
            width = 6
          ),
          
          valueBoxOutput(
            outputId = "n_apart",
            width = 6
          )
        )
        
      ),
      
      ### ---- baris 3----
      
      fluidRow(
        box(
          title = "Visualisasi Harga",
          collapsible = TRUE,
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          width = 6,
          
          plotlyOutput(outputId = "plot1")
          
          
      
        ),
        box(
          title = "Visualisasi Kota",
          collapsible = TRUE,
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          width = 6,
          
          plotlyOutput(outputId = "plot2")

        )
        
        
        
      ),
      
      ##----Baris ke 4----
      
      fluidRow(
        
        box(
          title = "Visualisasi Luas Bangunan",
          collapsible = TRUE,
          enable_label = TRUE,
          label_status = "danger",
          status = "primary", 
          solidHeader = FALSE, 
          width = 12,
          
          plotlyOutput(outputId = "plot3")
          
        )
        
      )
      
    ),
    
    
    
  ## ----PAGE 2----
    # Second tab content
  
    
    tabItem(tabName = "page2",
            
            ## ----row 1----
            fluidRow(
              box(
                title = strong("Prediksi Harga Rumah"),
                enable_label = TRUE,
                label_status = "danger",
                status = "primary", 
                solidHeader = FALSE,
                width = 12,
                p("Manfaatkan fitur prediksi untuk memperkirakan harga rumah
                  dengan memasukkan nilai-nilai tertentu,
                  seperti jumlah kamar, luas, dan lainnya.")
              )
            ),
            
            ## ----row 2----
            fluidRow(
              
              
              box(
                title = "Masukkan Karakteristik Rumah!",
                enable_label = TRUE,
                label_status = "danger",
                collapsible = TRUE,
                status = "primary", 
                solidHeader = FALSE,
                align = "center",
                width = 6,
                
                sliderInput("LUAS_BANGUNAN",
                             label = "Luas Bangunan",
                             value = 120,min = 0, max = 1000,
                             step = 10),
                numericInput("KAMAR_TIDUR",
                             label = "Jumlah Kamar Tidur",
                             value = 2,min = 0, max = 10),
                numericInput("KAMAR_MANDI",
                             label = "Jumlah Kamar Mandi",
                             value = 1,min = 0, max = 10),
                selectInput("KOTA",
                             label = "Kota",
                             choices =unique(properti_rumah$Kota),
                             selected = "Jakarta Selatan"),
                selectInput("SERTIFIKAT",
                             label = "Jenis Sertifikat",
                            choices =unique(properti_rumah$Sertifikat),
                            selected = "SHM - Sertifikat Hak Milik"),
                
                actionButton(inputId = "action", label = "Check the Result!")
                
                
              ),
              
              box(
                
                title = "Harga rumah hasil prediksinya adalah...",
                enable_label = TRUE,
                label_status = "danger",
                status = "primary", 
                solidHeader = FALSE,
                align = "center",
                width = 6, 
                valueBoxOutput(
                  outputId = "hasil_prediksi", 
                  width = 12
                )
                
                
              )
              
              
            )
            
            
            
    )
  )
)

# ----Dashboard Footer----

footer <-  dashboardFooter(
  left = "Dashbord by Dwi Gustin Nurdialit",
  right = "Copyright © 2024 algorit.ma"
)


# ----Dashboard Page----

dashboardPage(
  title = "Prediksi Harga Rumah",
  skin = "purple",
  header = header,
  body = body,
  sidebar = sidebar,
  footer = footer
)

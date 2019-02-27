# seed a df for 24h of data
cellphone <- data.frame(
  h0 = abs(round(rnorm(26, mean=10, sd=10),0)),
  h1 = abs(round(rnorm(26, mean=8, sd=10),0)),
  h2 = abs(round(rnorm(26, mean=5, sd=5),0)),
  h3 = abs(round(rnorm(26, mean=0, sd=1),0)),
  h4 = abs(round(rnorm(26, mean=0, sd=1),0)),
  h5 = abs(round(rnorm(26, mean=0, sd=1),0)),
  h6 = abs(round(rnorm(26, mean=0, sd=1),0)),
  h7 = abs(round(rnorm(26, mean=1, sd=1),0)),
  h8 = abs(round(rnorm(26, mean=2, sd=1),0)),
  h9 = abs(round(rnorm(26, mean=5, sd=2),0)),
  h10 = abs(round(rnorm(26, mean=20, sd=20),0)),
  h11 = abs(round(rnorm(26, mean=50, sd=20),0)),
  h12 = abs(round(rnorm(26, mean=50, sd=20),0)),
  h13 = abs(round(rnorm(26, mean=20, sd=10),0)),
  h14 = abs(round(rnorm(26, mean=20, sd=10),0)),
  h15 = abs(round(rnorm(26, mean=20, sd=10),0)),
  h16 = abs(round(rnorm(26, mean=20, sd=10),0)),
  h17 = abs(round(rnorm(26, mean=30, sd=20),0)),
  h18 = abs(round(rnorm(26, mean=40, sd=20),0)),
  h19 = abs(round(rnorm(26, mean=50, sd=10),0)),
  h20 = abs(round(rnorm(26, mean=60, sd=10),0)),
  h21 = abs(round(rnorm(26, mean=60, sd=10),0)),
  h22 = abs(round(rnorm(26, mean=40, sd=10),0)),
  h23 = abs(round(rnorm(26, mean=10, sd=10),0))
)

# transpose so that columns are individuals
cellphone.t <- t(cellphone)

# per column: adjust with a factor to generate a pattern specific per person
for(n in colnames(cellphone.t)){
  f <- runif(1)
  cellphone.t[,n] <- round(f*(cellphone.t[,n]),0)
}

# transpose back to individuals in rows
cellphone <- t(cellphone.t)

# back to df
cellphone <- as.data.frame(cellphone)

# add names
row.names(cellphone) <- c("Ann","Bob","Charlotte","Drew","Elody","Farouk","Georgia","Hetty","Isaac",
                           "Jane","Karl","Laura","Matt","Naomi","Onno","Patricia","Quentin","Reese",
                           "Simon","Tammy","Ulf","Vera","Wendy","Xavier","Yvonne","Zach")

# save to a csv for further processing
write.csv(cellphone,file="surfdrive/Shared/DataCafeR/presentations/heatmaps/cellphone_raw.csv")

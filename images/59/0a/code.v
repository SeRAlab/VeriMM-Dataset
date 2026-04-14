module top_module(

  
  fmc_dac_db,
  fmc_dac_sleep,
  fmc_clkd_spi_sclk,
  fmc_clkd_spi_csb,
  fmc_clkd_spi_sdio,

  fmc_clkd_syncn,
  fmc_clkd_resetn,
  

  
  
  

  
  dac_db,
  dac_sleep,

  clkd_spi_sclk,
  clkd_spi_csb,
  clkd_spi_sdio,
  
  clkd_syncn,
  clkd_resetn
);input [13:0]  fmc_dac_db;
  input         fmc_dac_sleep;
  input         fmc_clkd_spi_sclk;
  input         fmc_clkd_spi_csb;
  inout         fmc_clkd_spi_sdio;

  input         fmc_clkd_syncn;
  input         fmc_clkd_resetn;
  

  
  
  

  
  output  [13:0]  dac_db;
  output          dac_sleep;

  output          clkd_spi_sclk;
  output          clkd_spi_csb;
  inout           clkd_spi_sdio;
  
  output          clkd_syncn;
  output          clkd_resetn;

  reg [15:0]  cnt ;
  reg         fpga_to_clkd ; 
  reg         spi_r_wn ;

  assign dac_db             = fmc_dac_db;
  assign dac_sleep          = fmc_dac_sleep;

  assign clkd_spi_sclk      = fmc_clkd_spi_sclk;
  assign clkd_spi_csb       = fmc_clkd_spi_csb;

  assign clkd_spi_sdio      = fpga_to_clkd ? fmc_clkd_spi_sdio : 1'bZ;
  assign fmc_clkd_spi_sdio  = fpga_to_clkd ? 1'bZ :clkd_spi_sdio;

  assign clkd_syncn         = fmc_clkd_syncn;
  assign clkd_resetn        = fmc_clkd_resetn;

  

  always @ (posedge fmc_clkd_spi_sclk or posedge fmc_clkd_spi_csb)
  begin
    if (fmc_clkd_spi_csb == 1'b1)
    begin
      cnt           <= 0;
      spi_r_wn      <= 1;
    end
    else
    begin
      cnt <= cnt + 1;
      if (cnt == 0)
      begin
        spi_r_wn <= fmc_clkd_spi_sdio;
      end
    end
  end

  always @(negedge fmc_clkd_spi_sclk or posedge fmc_clkd_spi_csb)
  begin
    if (fmc_clkd_spi_csb == 1'b1)
    begin
      fpga_to_clkd <= 1;
    end
    else
    begin
      if (cnt == 16)
      begin
        fpga_to_clkd <= ~spi_r_wn;
      end
    end
  end

endmodule
module top_module(
  spi_csn,
  spi_clk,
  spi_mosi,
  spi_miso,
  spi_sdio,
  spi_dir
);// 4 wire
  input   [2:0]  spi_csn;
  input           spi_clk;
  input           spi_mosi;
  output          spi_miso;

  // 3 wire
  inout           spi_sdio;
  output          spi_dir;

  // internal registers
  reg     [5:0]  spi_count = 'd0;
  reg             spi_rd_wr_n = 'd0;
  reg             spi_enable = 'd0;

  // internal signals
  wire            spi_csn_s;
  wire            spi_enable_s;

  // check on rising edge and change on falling edge
  assign spi_csn_s = &spi_csn;
  assign spi_dir = ~spi_enable_s;
  assign spi_enable_s = spi_enable & ~spi_csn_s;

  always @(posedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_count <= 6'd0;
      spi_rd_wr_n <= 1'b0;
    end else begin
      spi_count <= spi_count + 1'b1;
      if (spi_count == 6'd0) begin
        spi_rd_wr_n <= spi_mosi;
      end
    end
  end

  always @(negedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s == 1'b1) begin
      spi_enable <= 1'b0;
    end else begin
      if (spi_count == 6'd16) begin
        spi_enable <= spi_rd_wr_n;
      end
    end
  end

  // Buffer implementation
  assign spi_miso = (spi_enable_s) ? spi_mosi : 1'bz;  // Tri-state buffer behavior for IOBUF replacement
  assign spi_sdio = spi_enable_s ? spi_mosi : 1'bz;    // Output data on spi_sdio when enabled

endmodule
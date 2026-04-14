module top_module(
  input spi_csn_0,
  input spi_csn_1,
  input spi_clk,
  input spi_mosi,
  inout spi_sdio,
  output spi_miso,
  output spi_dirn
);// Internal registers and signals
  reg [5:0] spi_count = 6'b0;
  reg spi_rd_wr_n = 1'b0;
  reg spi_enable = 1'b0;
  reg spi_miso_reg = 1'bz; // Register for MISO output
  wire spi_csn_s = spi_csn_0 & spi_csn_1;
  wire spi_enable_s = spi_enable & ~spi_csn_s;

  // Assign signals
  assign spi_dirn = ~spi_enable_s;

  // Logic for MISO output
  always @(*) begin
    if (spi_enable_s) begin
      spi_miso_reg = spi_mosi; // Drive the signal when enabled
    end else begin
      spi_miso_reg = 1'bz; // High Impedance otherwise
    end
  end

  assign spi_miso = spi_miso_reg; // Connect the register to output

  // Count bits and sample MOSI
  always @(posedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s) begin
      spi_count <= 6'b0;
      spi_rd_wr_n <= 1'b0;
    end else begin
      spi_count <= spi_count + 1'b1;
      if (spi_count == 6'b0) begin
        spi_rd_wr_n <= spi_mosi;
      end
    end
  end

  // Enable SPI interface and control direction
  always @(negedge spi_clk or posedge spi_csn_s) begin
    if (spi_csn_s) begin
      spi_enable <= 1'b0;
    end else begin
      if (spi_count == 6'b10000) begin
        spi_enable <= spi_rd_wr_n;
      end
    end
  end

  // For a simple inout mechanism without IOBUF
  assign spi_sdio = (spi_enable_s) ? spi_mosi : 1'bz; // Output MISO or High Z
  assign spi_mosi = (spi_enable_s) ? spi_miso_reg : 1'bz; // Drive the line when enabled

endmodule
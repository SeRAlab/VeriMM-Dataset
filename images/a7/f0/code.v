module top_module(
    out,
    rd_rst_asreg_reg,
    in0,
    ext_spi_clk
);output reg out;
  output reg rd_rst_asreg_reg;
  input in0;
  input ext_spi_clk;

  reg in0_sync;

  always @(posedge ext_spi_clk) begin
    in0_sync <= in0;
  end

  always @(posedge ext_spi_clk, posedge rd_rst_asreg_reg) begin
    if (rd_rst_asreg_reg) begin
      out <= 1'b0;
    end else begin
      out <= in0_sync;
    end
  end

endmodule
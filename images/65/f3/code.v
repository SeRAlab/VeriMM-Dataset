module top_module(ram_full_fb_i_reg,
    Q,
    wr_pntr_gc_reg,
    rd_pntr_bin_reg,
    E,
    ext_spi_clk,
    AR);output ram_full_fb_i_reg;
  output [3:0] Q;
  output [3:0] wr_pntr_gc_reg;
  input [3:0] rd_pntr_bin_reg;
  input [0:0] E;
  input ext_spi_clk;
  input [0:0] AR;

  reg [3:0] Q;
  reg [3:0] wr_pntr_gc_reg;
  reg ram_full_fb_i_reg;
  wire [3:0] plusOp__2;
  
  reg [3:0] wr_pntr_plus2; // Change wire to reg
  reg [3:0] wr_pntr_plus3; // Change wire to reg

  always @(posedge ext_spi_clk) begin
    if (AR) begin
      Q <= 4'b0;
      wr_pntr_gc_reg <= 4'b0;
      ram_full_fb_i_reg <= 1'b0; // Reset ram_full_fb_i_reg in case of asynchronous reset
    end
    else if (E) begin
      Q <= Q + 1;
      wr_pntr_plus2 <= wr_pntr_gc_reg + 2;
      wr_pntr_plus3 <= {wr_pntr_plus2[3], wr_pntr_plus2[2:0]}; // Update wr_pntr_plus3
      wr_pntr_gc_reg <= (wr_pntr_gc_reg == 4'b1111) ? 4'b0 : wr_pntr_plus3;
      ram_full_fb_i_reg <= (rd_pntr_bin_reg == wr_pntr_gc_reg);
    end
  end

endmodule
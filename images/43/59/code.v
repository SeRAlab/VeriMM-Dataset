module top_module(D,
    Q,
    ext_spi_clk,
    AR,
    Q_reg);output [3:0] D;
  input [3:0] Q;
  input ext_spi_clk;
  input AR; // Changed AR to a 1-bit wire instead of a one-dimensional array
  output [3:0] Q_reg;

  wire [3:0] Q_reg_async; // Moved the declaration of Q_reg_async up and removed redundant wiring
  wire ext_spi_clk;

  assign D = Q_reg;

  // Changed FDCE to a generic D flip-flop implementation
  reg Q_reg_async_0, Q_reg_async_1, Q_reg_async_2, Q_reg_async_3;

  always @(posedge ext_spi_clk or posedge AR) begin
    if (AR) begin
      Q_reg_async_0 <= 1'b0;
      Q_reg_async_1 <= 1'b0;
      Q_reg_async_2 <= 1'b0;
      Q_reg_async_3 <= 1'b0;
    end else begin
      Q_reg_async_0 <= Q[0];
      Q_reg_async_1 <= Q[1];
      Q_reg_async_2 <= Q[2];
      Q_reg_async_3 <= Q[3];
    end
  end
  
  assign Q_reg = {Q_reg_async_3, Q_reg_async_2, Q_reg_async_1, Q_reg_async_0}; // Adjusted for concatenation
  
endmodule
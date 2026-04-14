module top_module(AS,
    out,
    rd_clk,
    in0);output [0:0] AS;
  input out;
  input rd_clk;
  input [0:0] in0;

  wire [0:0] AS;
  wire Q_reg;
  reg [0:0] in0_reg;
  wire out;
  wire rd_clk;

  // Replace FDRE with a simple D flip-flop implementation
  reg Q_reg_ff;

  always @(posedge rd_clk) begin
    if (AS[0] == 1'b0) // Active low reset
      Q_reg_ff <= 1'b0;
    else
      Q_reg_ff <= out;
  end

  assign Q_reg = Q_reg_ff;

  // Replace LUT2 with a simple AND gate implementation
  assign AS[0] = in0_reg[0] & Q_reg;

  always @(posedge rd_clk) begin
    in0_reg <= in0;
  end
endmodule
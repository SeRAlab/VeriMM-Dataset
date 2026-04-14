module top_module(
  input  wire clk,
  input  wire hardreset,
  output wire reset
);reg [3:0] reset_reg = 4'hF;
assign reset = reset_reg[3];

always @ (posedge clk, posedge hardreset)
if (hardreset) reset_reg <= 4'hF;
else           reset_reg <= {reset_reg,1'b0};

endmodule
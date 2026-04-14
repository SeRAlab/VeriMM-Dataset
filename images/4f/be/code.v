module top_module(
  input [n-1:0] in,
  input clk,
  input rst,
  input [n-1:0] wiper_pos,
  output reg [n-1:0] resistance
);parameter n = 8; // number of bits used to represent resistance value
parameter r = 1000; // total resistance value of the resistor ladder network (in ohms)

reg [n-1:0] wiper_pos_reg;
reg [(n+1)-1:0] resistor_ladder; // Changed this to fix width issues

// Calculate resistance values for a linear resistor ladder
integer i;
always @ (posedge clk) begin
  if (rst) begin
    wiper_pos_reg <= 0;
    resistor_ladder <= 0;
    resistance <= 0;
  end else begin
    wiper_pos_reg <= wiper_pos;
    for (i = 0; i < (2**n); i = i + 1) begin
      resistor_ladder[i] = (r / (2**n)) * (i);
    end
    resistance <= resistor_ladder[wiper_pos_reg];
  end
end

endmodule
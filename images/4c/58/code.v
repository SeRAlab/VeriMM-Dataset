module top_module(
  input clk,
  input [7:0] in,
  output reg parity_bit
);integer i;
  reg [7:0] in_reg;
  reg parity_calculated;
  
  always @(posedge clk) begin
    in_reg <= in;
    parity_calculated <= 1'b0;
    for (i = 0; i < 8; i = i + 1) begin
      parity_calculated <= parity_calculated ^ in_reg[i];
    end
    parity_bit <= parity_calculated;
  end
  
endmodule
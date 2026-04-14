module top_module(
  input clk,
  input [3:0] binary_input,
  output [3:0] gray_output
);reg [3:0] gray_reg;
  
  always@(posedge clk) begin
    gray_reg[3] <= binary_input[3];
    gray_reg[2] <= binary_input[3] ^ binary_input[2];
    gray_reg[1] <= binary_input[2] ^ binary_input[1];
    gray_reg[0] <= binary_input[1] ^ binary_input[0];
  end
  
  assign gray_output = gray_reg;
  
endmodule
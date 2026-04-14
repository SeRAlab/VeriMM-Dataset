module top_module(clk, a_in, a_out, b_out, b_in, enable);input clk; 
  input enable; 
  input signed [31:0] a_in, b_in; 
  output reg signed [31:0] a_out, b_out; 
  parameter weight = 0; 
  initial begin 
  a_out <= 32'h0; 
  b_out <= 32'h0; 
  end 
  always @(posedge clk) begin 
  if(enable) begin 
  b_out <= b_in + $signed(weight) * a_in; 
  a_out <= a_in; 
  end 
  end 
 endmodule
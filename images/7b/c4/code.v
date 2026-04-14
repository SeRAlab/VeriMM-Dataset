module top_module(input clk,input reset,input [1:0]select,input [3:0]sig_in,output reg sig_out);always @(posedge clk or posedge reset) 
  begin 
  if (reset) sig_out <= 0; 
  else 
  case (select) 
  0: sig_out <= sig_in[0]; 
  1: sig_out <= sig_in[1]; 
  2: sig_out <= sig_in[2]; 
  3: sig_out <= sig_in[3]; 
  endcase 
  end 
 endmodule
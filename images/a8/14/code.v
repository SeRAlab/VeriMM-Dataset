module top_module(input clk,input [31:0] addr_b,input [31:0] data_b_in,input [31:0] data_b_we);always @(posedge clk) 
  begin 
  if (addr_b == 65536) 
  $write("%c", data_b_in[7:0]); 
  end 
 endmodule
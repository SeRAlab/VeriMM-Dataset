module top_module(input clk,output out);reg [1:0] cnt = 0; 
  wire clk_int; 
  assign clk_int = clk; 
  always @(posedge clk_int) begin 
  cnt <= cnt + 1; 
  end 
  assign out = cnt[0]; 
 endmodule
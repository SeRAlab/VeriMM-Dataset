module top_module(
input         clk,           
              rst_n,           
              async_in,      
output        sync_out);reg    [ 1:0] shift;         

always @(negedge clk or negedge rst_n)
  if (~rst_n) shift[0] <= 1;    
  else shift[0] <= async_in; 
always @(posedge clk or negedge rst_n)
  if (~rst_n) shift[1] <= 1;    
  else shift[1] <= shift[0]; 

assign sync_out = shift[1];  

endmodule
module top_module(input clk,input in_rst_n,output out_rst_n);reg [1:0] ff; 
 always @(posedge clk or negedge in_rst_n) begin 
  if(!in_rst_n) begin 
  ff[1] <= 1'b0; 
  ff[0] <= 1'b0; 
  end 
  else begin 
  ff[1] <= 1'b1; 
  ff[0] <= ff[1]; 
  end 
 end 
 assign out_rst_n = ff[0]; 
 endmodule
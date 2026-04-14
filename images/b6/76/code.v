module top_module(input d,output reg q,input en,input clk,input rst);always @(posedge clk or posedge rst) begin 
  if (rst) begin 
  q <= 1'b0; 
  end else if (en) begin 
  q <= d; 
  end 
  end 
 endmodule
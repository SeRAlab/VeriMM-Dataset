module top_module(input d, clk,output reg q);always @(posedge clk) begin 
  if (q != d) q = d; 
  end 
 endmodule
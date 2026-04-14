module top_module(input clk,input d,output reg [1:0] q);always @* begin 
  q[1] = d; 
  end 
  always @* begin 
  q[0] = q[1]; 
  end 
 endmodule
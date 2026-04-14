module top_module(q, d, clk, s);output q; 
 input d, clk, s; 
  reg q; 
  always @(posedge clk or posedge s) begin 
  if (s) 
  q <= #1 1'b1; 
  else 
  q <= #1 d; 
  end 
 endmodule
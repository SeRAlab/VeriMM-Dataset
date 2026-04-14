module top_module(q, d, clk, c);output q; 
 input d, clk, c; 
  reg q; 
  always @(posedge clk or posedge c) begin 
  if (c) 
  q <= #1 1'b0; 
  else 
  q <= #1 d; 
  end 
 endmodule
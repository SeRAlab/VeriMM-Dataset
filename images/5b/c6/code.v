module top_module(Input, Output);input [8:0] Input; 
  output [8:0] Output; 
  genvar i; 
  generate 
  for (i = 0; i < 8; i = i + 1) begin : ap 
  assign Output[(i>0) ? i-1 : 8] = Input[(i>0) ? i-1 : 8]; 
  end 
  endgenerate 
 endmodule
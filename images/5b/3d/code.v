module top_module(res,rst);output res; 
  input rst; 
  reg res = 1'b0; 
  always @(posedge rst) begin 
  if (rst == 1'b1) begin 
  res <= 1'b1; 
  end 
  end 
 endmodule
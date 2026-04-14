module top_module(clk, toggle);input clk; 
  input toggle; 
  always @ (posedge clk) begin 
  if (toggle) begin 
  end 
  if (toggle) begin 
  $write(""); 
  end 
  end 
 endmodule
module top_module(clk, toggle_up);input clk; 
  input toggle_up; 
  always @ (posedge clk) begin 
  if (0 && toggle_up) begin end 
  end 
 endmodule
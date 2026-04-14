module top_module(clk);parameter period = 20; 
  output clk; 
  reg clk; 
  always #(period/2) clk = !clk; 
  initial begin 
  clk = 1'b0; 
  end 
 endmodule
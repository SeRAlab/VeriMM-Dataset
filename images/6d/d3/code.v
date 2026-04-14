module top_module(clk);output clk; 
  reg clk; 
  parameter FREQ=4_000_000; 
  initial begin 
  clk<=0; 
  end 
  always @(clk) begin 
  #(1_000_000_000/FREQ/2) clk<=~clk; 
  end 
 endmodule
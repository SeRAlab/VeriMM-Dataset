module top_module(input clk, output slow_clk);parameter TICKS = 27'd49_999_999; 
  reg [31:0] count = 0; 
  reg sig_reg = 0; 
  always @(posedge clk) begin 
  if (count == TICKS) begin 
  sig_reg <= ~sig_reg; 
  count <= 0; 
  end 
  else begin 
  count <= count + 1; 
  end 
  end 
  assign slow_clk = sig_reg; 
 endmodule
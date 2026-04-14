module top_module(input clk_i,output clk_o);parameter div = 2; 
  reg r_clk_o; 
  reg [31:0] count; 
  initial begin 
  r_clk_o = 0; 
  count = 0; 
  end 
  always @(posedge clk_i) begin 
  count = count + 1; 
  if(count == div) begin 
  count = 0; 
  r_clk_o = ~r_clk_o; 
  end 
  end 
  assign clk_o = r_clk_o; 
 endmodule
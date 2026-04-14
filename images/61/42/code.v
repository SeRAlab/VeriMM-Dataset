module top_module(input clk_50mhz,output reg clk_1hz);reg [31:0] count; 
  always @(posedge clk_50mhz) 
  begin 
  count <= count + 1; 
  if(count == 2500000) begin 
  count <= 0; 
  clk_1hz <= ~clk_1hz; 
  end 
  end 
  endmodule
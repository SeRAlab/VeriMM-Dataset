module top_module(clk, ibus, ibusWire);input [31:0] ibus; 
  input clk; 
  output [31:0] ibusWire; 
  reg [31:0] ibusWire; 
  always @(posedge clk) begin 
  ibusWire = ibus; 
  end 
 endmodule
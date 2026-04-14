module top_module(clk, ibus, ibusWire, PCIn, PCOut);input [31:0] ibus; 
  input [63:0] PCIn; 
  input clk; 
  output [31:0] ibusWire; 
  output [63:0] PCOut; 
  reg [31:0] ibusWire; 
  reg [63:0] PCOut; 
  always @(posedge clk) begin 
  ibusWire = ibus; 
  PCOut = PCIn; 
  end 
 endmodule
module top_module(clk, ibus, ibusWire, PCIn, PCOut);input [31:0] ibus, PCIn;
  input clk;
  output [31:0] ibusWire, PCOut;
  reg [31:0] ibusWire, PCOut;
  always @(posedge clk) begin
    
    ibusWire = ibus;
    PCOut = PCIn;
  end
endmodule
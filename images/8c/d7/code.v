module top_module(dataIn, clk, dataOut, opCodeThingIn, opCodeThingOut);input [31:0] dataIn;
  input clk;
  output [31:0] dataOut;
  reg [31:0] dataOut;
  input [5:0] opCodeThingIn;
  output [5:0] opCodeThingOut;
  reg [5:0] opCodeThingOut;
  always @(posedge clk) begin
    dataOut = dataIn;
    opCodeThingOut = opCodeThingIn;
  end
endmodule
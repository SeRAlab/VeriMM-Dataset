module top_module(dataIn, clk, dataOut);input [31:0] dataIn;
  input clk;
  output [31:0] dataOut;
  reg [31:0] dataOut;
  always @(posedge clk) begin
    dataOut = dataIn;
  end
endmodule
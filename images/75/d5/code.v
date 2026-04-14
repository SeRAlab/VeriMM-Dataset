module top_module(input controlSignal, input [31:0] input0, input [31:0] input1, output reg [31:0] muxOut);always @(*)
begin
  if (controlSignal == 0)
    muxOut = input0;
  else
    muxOut = input1;
end

endmodule
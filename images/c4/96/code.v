module Bitwise_Or (
  input [31:0] in0,
  input [31:0] in1,
  input enable,
  output reg [31:0] out
);
  always @(*) begin
    if (enable) begin
      out = in0 | in1;
    end else begin
      out = 32'b0;
    end
  end
endmodule
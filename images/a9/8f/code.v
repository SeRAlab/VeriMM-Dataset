module top_module(
  input [15:0] in1,
  input [15:0] in2,
  input op,
  output reg [15:0] out
);always @* begin
    if (op == 1'b0) // unsigned addition
      out = in1 + in2;
    else // signed addition
      out = $signed(in1) + $signed(in2);
  end

endmodule
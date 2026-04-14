module top_module(
  input [7:0] in0,
  input [7:0] in1,
  input [7:0] in2,
  input [7:0] in3,
  input [1:0] sel,
  output reg [7:0] out
);always @ (sel or in0 or in1 or in2 or in3)
    case (sel)
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
      2'b11: out = in3;
    endcase

endmodule
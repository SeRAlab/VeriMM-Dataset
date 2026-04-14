module mux_4to1_case (
  input [3:0] in0,
  input [3:0] in1,
  input [3:0] in2,
  input [3:0] in3,
  input sel0,
  input sel1,
  output reg [3:0] out
);

  always @ (sel0 or sel1 or in0 or in1 or in2 or in3)
    case ({sel1, sel0})
      2'b00: out <= in0;
      2'b01: out <= in1;
      2'b10: out <= in2;
      2'b11: out <= in3;
    endcase

endmodule

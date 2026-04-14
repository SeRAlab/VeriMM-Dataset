module mux4(sel1, sel0, in0, in1, in2, in3, out);
  input sel1, sel0, in0, in1, in2, in3;
  output out;

  always @ (*)
    case ({sel1, sel0})
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
      2'b11: out = in3;
    endcase

endmodule
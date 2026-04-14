module top_module(
  output O,
  input DI,
  (* invertible_pin = "IS_SRI_INVERTED" *)
  input SRI
);parameter [0:0] IS_SRI_INVERTED = 1'b0;
  assign O = DI | (SRI ^ IS_SRI_INVERTED);
endmodule
module and_enable (
  input a,
  input b,
  input enable,
  output out
);

  wire and_result;

  and_gate and_inst (
    .a(a),
    .b(b),
    .out(and_result)
  );

  assign out = enable ? and_result : 1'b0;

endmodule

module and_gate (
  input a,
  input b,
  output out
);

  assign out = a & b;

endmodule
module top_module(
    (* iopad_external_pin *)
    output P,
    input  A
);specify
    (A => P) = 0;
  endspecify
  assign P = A;
endmodule
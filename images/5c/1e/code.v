module top_module(
    output Q,
    (* iopad_external_pin *)
    input  P
);specify
    (P => Q) = 0;
  endspecify
  assign Q = P;
endmodule
module top_module(
    (* clkbuf_inv = "I" *)
    output O,
    input I
);assign O = !I;
  specify
    (I => O) = 127;
  endspecify
endmodule
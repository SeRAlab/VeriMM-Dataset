module top_module(
    (* clkbuf_driver *)
    output O,
    input I);assign O = I;
  specify
    
    (I => O) = 96;
  endspecify
endmodule
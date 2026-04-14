module top_module(
    output O,
    (* iopad_external_pin *)
    input I);parameter IOSTANDARD = "default";
  parameter IBUF_LOW_PWR = 0;
  assign O = I;
  specify
    (I => O) = 0;
  endspecify
endmodule
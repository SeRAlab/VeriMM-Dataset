module top_module(
    (* iopad_external_pin *)
    output O,
    input I);parameter IOSTANDARD = "default";
  parameter DRIVE = 12;
  parameter SLEW = "SLOW";
  assign O = I;
  specify
    (I => O) = 0;
  endspecify
endmodule
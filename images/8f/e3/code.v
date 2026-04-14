module top_module(
  input  I,
  (* iopad_external_pin *)
  output O
);parameter IOSTANDARD   = "default";
  parameter DRIVE        = 12;
  parameter SLEW         = "SLOW";
  parameter IO_LOC_PAIRS = ""; 

  assign O = I;
  specify
    (I => O) = 0;
  endspecify

endmodule
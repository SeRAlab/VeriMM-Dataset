module top_module(
  (* iopad_external_pin *)
  input  I,
  output O
);parameter IOSTANDARD   = "default";
  parameter IBUF_LOW_PWR = 0;
  parameter IN_TERM = "NONE";  
  parameter IO_LOC_PAIRS = ""; 

  assign O = I;
  specify
    (I => O) = 0;
  endspecify

endmodule
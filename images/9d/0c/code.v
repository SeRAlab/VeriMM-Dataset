module top_module(
  input voltage,
  output current
);parameter I_source = 1; // value of the current source (in amperes)
  parameter I_sink = 1; // value of the current sink (in amperes)

  assign current = (voltage > 0) ? I_source : ((voltage < 0) ? -I_sink : 0);

endmodule
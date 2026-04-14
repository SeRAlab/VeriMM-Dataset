module top_module(
  input ctrl,
  input [7:0] vref,
  output isrc,
  output isnk
);parameter imax = 10; // maximum current
parameter r = 100; // load resistance

assign isrc = (ctrl) ? vref / r : 0; // current source
assign isnk = (ctrl) ? 0 : vref / r; // current sink

endmodule
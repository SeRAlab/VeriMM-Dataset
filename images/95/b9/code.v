module top_module(
  input [n-1:0] in,
  output par,
  output err
);parameter n = 4; // number of input signals

assign par = ^in; // generate parity bit as XOR of input bits

assign err = (par ^ ^in) ? 1 : 0; // check parity and set error flag accordingly

endmodule
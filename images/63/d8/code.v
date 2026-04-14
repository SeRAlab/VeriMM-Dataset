module top_module(
  input signbit,
  input allzeros,
  output [1:0] result);assign result = {(allzeros & signbit),(allzeros & ~(signbit))};endmodule
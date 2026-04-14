module top_module(
  input wire INA,
  input wire INB,
  input wire INC,
  output wire TWOPOS,
  output wire TWONEG,
  output wire ONEPOS,
  output wire ONENEG
);assign TWOPOS = (INA & INB & ~INC);
  assign TWONEG = (~INA & ~INB & INC);
  assign ONEPOS = ((~INA & INB & ~INC) | (~INC & ~INB & INA));
  assign ONENEG = ((INA & ~INB & INC) | (INC & INB & ~INA));

endmodule
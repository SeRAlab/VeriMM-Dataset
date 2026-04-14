module top_module(
  input ONEPOS,
  input ONENEG,
  input TWOPOS,
  input TWONEG,
  input INA,
  input INB,
  input INC,
  input IND,
  output PPBIT
);assign PPBIT = ~( 
    ( ~(INA & TWOPOS) ) & 
    ( ~(INB & TWONEG) ) & 
    ( ~(INC & ONEPOS) ) & 
    ( ~(IND & ONENEG) )
  );

endmodule
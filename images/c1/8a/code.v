module PP_LOW ( ONEPOS, ONENEG, TWONEG, INA, INB, PPBIT );
input  ONEPOS;
input  ONENEG;
input  TWONEG;
input  INA;
input  INB;
output PPBIT;
   assign PPBIT = (ONEPOS & INA) | (ONENEG & INB) | TWONEG;
endmodule
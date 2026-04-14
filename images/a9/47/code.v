module top_module(IN1, IN2, IN3, IN4, QN);input IN1, IN2, IN3, IN4;
  output QN;

  wire Otemp0, Otemp1;

  // OR gate implementation for IN1 and IN2 to produce Otemp0
  assign Otemp0 = IN1 | IN2;

  // OR gate implementation for IN3 and IN4 to produce Otemp1
  assign Otemp1 = IN3 | IN4;

  // NAND gate implementation for Otemp0 and Otemp1 to produce QN
  assign QN = ~(Otemp0 & Otemp1);

endmodule
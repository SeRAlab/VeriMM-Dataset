module top_module(IN1, IN2, IN3, IN4, QN);input IN1, IN2, IN3, IN4;
  output QN;

  wire Otemp0, Otemp1;

  assign Otemp0 = ~(IN1 & IN2);
  assign Otemp1 = ~(IN3 & IN4);

  assign QN = ~(Otemp0 & Otemp1);

endmodule
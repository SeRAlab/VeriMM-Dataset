module top_module(IN1, IN2, IN3, IN4, Q);input IN1;
  input IN2;
  input IN3;
  input IN4;
  output Q;

  wire AND1;
  wire AND2;
  wire AND3;

  assign AND1 = IN1 & IN2;
  assign AND2 = IN3 & IN4;
  assign AND3 = AND1 & AND2;

  assign Q = AND3;

endmodule
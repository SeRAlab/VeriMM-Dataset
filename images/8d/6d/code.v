module top_module(input IN1, IN2, IN3, IN4, output QN, input VDD, VSS);wire and1, and2, or1;
  
  assign and1 = IN1 & IN2;
  assign and2 = IN3 & IN4;
  assign or1 = and1 | and2;
  assign QN = ~or1;

endmodule
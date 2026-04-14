module top_module(input IN1, IN2, IN3, IN4, IN5, IN6, output QN, output QN_, input VDD, VSS);wire AND1, AND2, NOR1;

  assign AND1 = IN1 & IN2;
  assign AND2 = ~(IN3 | IN4 | IN5 | IN6);
  assign NOR1 = ~(AND1 | AND2);

  assign QN = NOR1;
  assign QN_ = ~NOR1;

endmodule
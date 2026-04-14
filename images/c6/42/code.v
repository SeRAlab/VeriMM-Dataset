module NOR4X0 (input IN1, IN2, IN3, IN4, output QN, input VDD, VSS);

  wire n1, n2, n3;

  assign n1 = ~(IN1 | IN2);
  assign n2 = ~(IN3 | IN4);
  assign n3 = ~(n1 | n2);

  assign QN = n3;

endmodule
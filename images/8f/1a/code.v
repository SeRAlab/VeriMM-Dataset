module top_module(IN1, IN2, IN3, IN4, S0, S1, Q);input IN1, IN2, IN3, IN4, S0, S1;
  output Q;

  wire t1, t2, t3, t4, t5;

  // First 2:1 MUX
  wire mux1_out;
  wire mux2_out;

  // 2:1 MUX definition
  assign mux1_out = (S0) ? IN2 : IN1;
  assign mux2_out = (S0) ? IN4 : IN3;

  // NOT gate for S1
  wire not_s1;
  assign not_s1 = ~S1;

  // AND gate for S1 and mux1_out
  wire and1_out;
  assign and1_out = S1 & mux1_out;

  // AND gate for mux2_out and not_s1
  wire and2_out;
  assign and2_out = mux2_out & not_s1;

  // Final output MUX
  assign Q = (S1) ? and1_out : and2_out;

endmodule
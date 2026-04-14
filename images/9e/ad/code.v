module top_module(
  input signed [35:0] preIntegrator,
  input signed [35:0] preSat,
  input saturated,
  output Clamp
);wire Compare_To_Zero_out1;
  wire Compare_To_Zero1_out1;
  wire Compare_To_Zero_out1_1;
  wire Logical_Operator_out1;

  // Compare preIntegrator to zero
  assign Compare_To_Zero_out1 = (preIntegrator <= 36'sh000000000 ? 1'b1 : 1'b0);

  // Compare preSat to zero
  assign Compare_To_Zero1_out1 = (preSat <= 36'sh000000000 ? 1'b1 : 1'b0);

  // Logical OR of Compare_To_Zero_out1 and Compare_To_Zero1_out1
  assign Compare_To_Zero_out1_1 = ~ (Compare_To_Zero_out1 ^ Compare_To_Zero1_out1);

  // Logical AND of Compare_To_Zero_out1_1 and saturated
  assign Logical_Operator_out1 = Compare_To_Zero_out1_1 & saturated;

  // Output the result
  assign Clamp = Logical_Operator_out1;

endmodule
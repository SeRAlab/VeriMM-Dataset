module top_module(A, B, output_signal);input [7:0] A;
  input [7:0] B;
  output output_signal;

  wire [7:0] and_result;

  and and_gate_0 (and_result[0], A[0], B[0]);
  and and_gate_1 (and_result[1], A[1], B[1]);
  and and_gate_2 (and_result[2], A[2], B[2]);
  and and_gate_3 (and_result[3], A[3], B[3]);
  and and_gate_4 (and_result[4], A[4], B[4]);
  and and_gate_5 (and_result[5], A[5], B[5]);
  and and_gate_6 (and_result[6], A[6], B[6]);
  and and_gate_7 (and_result[7], A[7], B[7]);

  assign output_signal = and_result[0] & and_result[1] & and_result[2] & and_result[3] & and_result[4] & and_result[5] & and_result[6] & and_result[7];

endmodule
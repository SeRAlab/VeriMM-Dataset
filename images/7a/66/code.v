module top_module(
  Y,
  A,
  B_N,
  VPWR
);output Y;
  input A;
  input [1:0] B_N;
  input VPWR;

  wire [2:0] input_signal;

  assign input_signal = {~A, B_N};

  assign Y = (VPWR == 1'b0) ? 1'b0 : (input_signal == 3'b101) ? 1'b1 : 1'b0;

endmodule
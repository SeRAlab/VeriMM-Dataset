module top_module(A,B,signal,out);input [4:0] A, B;
  input signal;
  output reg [4:0] out;
  always@(A or B or signal)
    out <= (signal == 1'b0 ? A : B);
endmodule
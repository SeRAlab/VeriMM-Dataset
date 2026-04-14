module top_module(A, B, Cin, Sum, Cout);input [15:0] A;
  input [15:0] B;
  input Cin;
  output [15:0] Sum;
  output Cout;
  
  wire [15:0] carry;
  wire [15:0] temp_sum;
  
  assign temp_sum[0] = A[0] ^ B[0] ^ Cin;
  assign carry[0] = (A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin);
  
  genvar i;
  generate
    for(i = 1; i < 16; i = i + 1) begin : adder_loop
      assign temp_sum[i] = A[i] ^ B[i] ^ carry[i-1];
      assign carry[i] = (A[i] & B[i]) | (A[i] & carry[i-1]) | (B[i] & carry[i-1]);
    end
  endgenerate
  
  assign Sum = temp_sum;
  assign Cout = carry[15];
  
endmodule
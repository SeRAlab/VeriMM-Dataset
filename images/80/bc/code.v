module top_module(A, B, Cin, Ctr, S, Cout);input [3:0] A, B;
  input Cin, Ctr;
  output [3:0] S;
  output Cout;
  
  wire [3:0] temp;
  wire C1, C2, C3;
  
  // Adder for regular addition
  assign temp = A + B + Cin;
  
  // Adder for subtraction (2's complement)
  assign temp = A + (~B) + Cin + 4'b0001;
  
  // Select the output based on the control input
  assign S = (Ctr == 1) ? temp : (A + B + Cin);
  
  // Determine the carry-out based on the control input
  assign Cout = (Ctr == 1) ? ~C3 : C3;
  
  // Generate the carry chain
  assign C1 = A[0] & B[0];
  assign C2 = A[1] & B[1] | C1;
  assign C3 = A[2] & B[2] | C2;
  
endmodule
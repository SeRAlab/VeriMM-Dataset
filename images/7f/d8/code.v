module top_module(Y,carryout,A,B,carryin);output [3:0]Y;
  output carryout;
  input [3:0]A,B;
  input carryin;

  wire [3:0]g,p;
  wire [4:0]c;
  
  assign c[0] = carryin; 
  
  assign Y[0] = A[0] ^ B[0] ^ c[0];
  
  assign c[1] = ( ( A[0] & B[0] ) | ( ( A[0] ^ B[0] ) & c[0] ) );
  
  assign Y[1] = A[1] ^ B[1] ^ c[1];
  
  
  
  assign c[2] = ( ( A[1] & B[1] ) | ( ( A[1] ^ B[1] ) & ( ( A[0] & B[0] ) | ( ( A[0] ^ B[0] ) & c[0] ) ) ) ); 
  
  assign Y[2] = A[2] ^ B[2] ^ c[2];
  
  
  
  
  
  assign c[3] = ( ( A[2] & B[2] ) | ( ( A[2] ^ B[2] ) & ( ( A[1] & B[1] ) | ( ( A[1] ^ B[1] ) & ( ( A[0] & B[0] ) | ( ( A[0] ^ B[0] ) & c[0] ) ) ) ) ) );
  
  assign Y[3] = A[3] ^ B[3] ^ c[3];
  
  
  
  
  
  
  
  assign c[4] = ( ( A[0] & B[0] ) | ( ( A[0] ^ B[0] ) & ( ( A[2] & B[2] ) | ( ( A[2] ^ B[2] ) & ( ( A[1] & B[1] ) | ( ( A[1] ^ B[1] ) & ( ( A[0] & B[0] ) | ( ( A[0] ^ B[0] ) & c[0] ) ) ) ) ) ) ) );  
  

  
  assign carryout = c[4];

  
endmodule
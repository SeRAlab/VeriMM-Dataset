module top_module(I,S,Y);input [0:7] I;
  wire [0:7] I;

  input [0:2] S; 
  wire [0:2] S;
  output Y;
  wire Y;

  wire A,B,C;

  assign A=S[0];
  assign B=S[1];
  assign C=S[2];

  assign Y=A?(B?(C?(I[7]):(I[6])):(C?(I[5]):(I[4]))):
  (B?(C?(I[3]):(I[2])):(C?(I[1]):(I[0])));

endmodule
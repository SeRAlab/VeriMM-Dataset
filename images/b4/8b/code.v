module top_module(Y, A, B, C, D, S);input [3:0] A, B, C, D;
  input [1:0] S;
  output Y;
  
  wire [3:0] notS;
  wire [3:0] selA, selB, selC, selD;
  
  assign notS = ~S;
  assign selA = {notS[1], notS[1], notS[0], notS[0]} & {A, A, A, A};
  assign selB = {notS[1], S[1], notS[0], S[0]} & {B, B, B, B};
  assign selC = {S[1], notS[1], S[0], notS[0]} & {C, C, C, C};
  assign selD = {S[1], S[1], S[0], S[0]} & {D, D, D, D};
  
  assign Y = selA | selB | selC | selD;
endmodule
module top_module(PP,GP,S,A,B,CI);output          PP,GP;                  
  output [3:0]    S;                      
  input  [3:0]    A,B;                    
  input           CI;                     

  wire [3:0] P =  A | B;
  wire [3:0] G =  A & B;

  wire  C1 =  G[0] | P[0]&CI;
  wire  C2 =  G[1] | P[1]&C1;
  wire  C3 =  G[2] | P[2]&C2;
  wire [3:0] C = { C3, C2, C1, CI };

  assign PP = & P[3:0];
  assign GP = G[3] | P[3]&G[2] | P[3]&P[2]&G[1] | P[3]&P[2]&P[1]&G[0];
  assign S  =  A ^ B ^ C ;
  
endmodule
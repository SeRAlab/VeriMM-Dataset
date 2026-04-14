module top_module(Func, CC, Condition);input [3:0] Func;
   input [2:0] CC;
   output Condition;

   wire ZeroFlag     = CC[2];
   wire SignFlag     = CC[1];
   wire OverflowFlag = CC[0];

   
   parameter YES = 4'h0;
   parameter LEQ = 4'h1;
   parameter L   = 4'h2;
   parameter EQ  = 4'h3;
   parameter NEQ = 4'h4;
   parameter GEQ = 4'h5;
   parameter G   = 4'h6;

   assign Condition = (Func == YES) |
                      (Func == LEQ & ((SignFlag ^ OverflowFlag) | ZeroFlag)) |
                      (Func == L   &  (SignFlag ^ OverflowFlag)) |
                      (Func == EQ  & ZeroFlag) |
                      (Func == NEQ & ~ZeroFlag) |
                      (Func == GEQ &  (~SignFlag ^ OverflowFlag)) |
                      (Func == G   & ((~SignFlag ^ OverflowFlag) | ~ZeroFlag));endmodule
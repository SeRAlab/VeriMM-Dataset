module top_module(
 input[1:0] sel,
 input[7:0] A, 
 input[7:0] B, 
 input[7:0] C, 
 input[7:0] D, 
 output reg[7:0] S
 );always @(*) 
  case(sel)
   2'b00 : S <= A ;
   2'b01 : S <= B ;
   2'b10 : S <= C ;
   2'b11 : S <= D ;
   default : S <= A ;
  endcase 

 endmodule
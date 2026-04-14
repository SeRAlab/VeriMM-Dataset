module top_module(A, B, S, Y);input [4:0] A, B;
   input       S;
   output [4:0] Y; 
   
   assign Y = (S == 1) ? B : A; 
   
endmodule
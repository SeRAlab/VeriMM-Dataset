module top_module(MO, A, B, S);input [7:0] A, B;
   input S;
   output [7:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule
module top_module(A, B, S, Y);input A, B, S;
   output Y;
   
   wire not_S, and1, and2, or1;
   
   not (not_S, S);
   and (and1, A, not_S);
   and (and2, B, S);
   or (or1, and1, and2);
   assign Y = or1;
   
endmodule
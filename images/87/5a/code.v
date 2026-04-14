module top_module( input D, CK, output reg Q);always@*
   if(!CK)
      Q <= D;endmodule
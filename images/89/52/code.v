module top_module( input D, CK, RN, output reg Q);always@(posedge CK or negedge RN)
   if(!RN)
      Q <= 1'b0;
   else
      Q <= D;endmodule
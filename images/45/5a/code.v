module top_module( input D, CK, SE, SI, output reg Q);always@(posedge CK)
   if(SE)
      Q <= SI;
   else
      Q <= D;endmodule
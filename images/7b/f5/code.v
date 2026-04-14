module top_module( input D, CK, RN, SE, SI, output reg Q);always@(posedge CK or negedge RN)
   if(!RN)
      Q <= 1'b0;
   else if(SE)
      Q <= SI;
   else
      Q <= D;endmodule
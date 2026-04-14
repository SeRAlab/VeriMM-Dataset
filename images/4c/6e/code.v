module top_module( input D, CK, SN, SE, SI, output reg Q);always@(posedge CK or negedge SN)
   if(!SN)
      Q <= 1'b1;
   else if(SE)
      Q <= SI;
   else
      Q <= D;endmodule
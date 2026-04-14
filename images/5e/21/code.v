module top_module(In1,In0,CapOut);input In1;
   input In0;
   output CapOut;
   
   assign CapOut = In1 & In0;endmodule
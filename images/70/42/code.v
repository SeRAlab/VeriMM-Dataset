module top_module(

   input                     Ain,
   input                     Bin,

   output                    ParityOut 
  );assign ParityOut = (~Ain & Bin) | (Ain & ~Bin);

endmodule
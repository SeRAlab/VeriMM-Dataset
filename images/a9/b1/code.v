module top_module(input Ain,input Bin,output CompOut);assign CompOut = (~Ain & ~Bin) | (Ain & Bin); 
 endmodule
module top_module(output O, input CI, DI, S);assign O = S ? CI : DI; 
 endmodule
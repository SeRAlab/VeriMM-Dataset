module top_module(input[9:0] hcount,input[9:0] vcount,output[16:0] addr);assign addr = (vcount[9:1] << 8) + (vcount[9:1] << 6) + (hcount >> 1); 
 endmodule
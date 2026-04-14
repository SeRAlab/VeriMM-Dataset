module top_module(input i4,input i3,input i2,input i1,input i0,output [4:0] o);assign o = {i4, i3, i2, i1, i0}; 
 endmodule
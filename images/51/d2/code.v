module top_module(out) ;parameter SIZE = 1;

output  [SIZE-1:0] out;







assign  out = {SIZE{1'b0}};


endmodule
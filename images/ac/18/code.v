module top_module(outp, inp);output[31:0] outp;
input[15:0] inp;

assign outp = (inp[15]==1)? {16'hFFFF,inp} : {16'h0000,inp};

endmodule
module top_module(sOut, cOut, in1, in2, cIn);output sOut, cOut;
input in1, in2, cIn;

assign sOut = in1 ^ in2 ^ cIn;
assign cOut = (in1 ^ in2) || (cIn && (in1 ^ in2));

endmodule
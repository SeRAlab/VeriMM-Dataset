module top_module(input in, output out);wire w1, w2;
assign w1 = in;
assign w2 = w1;
assign out = w2;
endmodule
module top_module(input signed [11:0] in, output signed [11:0] out);assign out = in > 0 ? in : -in;

endmodule
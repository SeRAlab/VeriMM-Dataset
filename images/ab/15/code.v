module top_module(a, b, c, z);input signed [19:0] a, b;
 input signed [24:0] c;
 output signed [24:0] z;

 assign z = a + b + c - (c >>> 1);
 endmodule
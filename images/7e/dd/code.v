module top_module(a, b);input signed [63:0] a;
output signed [63:0] b;

wire signed [31:0] a1;
wire signed [31:0] a2;
wire signed [31:0] c;
wire signed [31:0] d;

assign a1 = a[63:32];
assign a2 = a[31:0];
assign c = a1 & a2;
assign d = a1 | a2;
assign b = {c, d};

endmodule
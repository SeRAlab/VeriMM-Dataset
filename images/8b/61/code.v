module top_module(
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum
);wire [99:0] p, g, c;

assign p = a ^ b;
assign g = a & b;
assign c[0] = cin;

genvar i;
generate
    for (i = 1; i < 100; i = i + 1) begin
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
endgenerate

assign cout = c[99];
assign sum = a + b + cin;

endmodule
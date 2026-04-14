module top_module(
    input [7:0] a,
    input [7:0] b,
    output [8:0] s,
    output overflow
);wire [7:0] g, p, c;

assign g = a & b;
assign p = a ^ b;
assign c[0] = 1'b0;

genvar i;
generate
    for (i = 1; i < 8; i = i + 1) begin
        assign c[i] = (g[i-1] | (p[i-1] & c[i-1]));
    end
endgenerate

assign s = {c[7], p} + a + b;

assign overflow = ((a[7] == b[7]) && (a[7] != s[8]));

endmodule
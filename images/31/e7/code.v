module KoggeStoneAdder #(parameter N = 4) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] sum,
    output carry_out
);
    wire [N:0] p, g, c;

    assign p = a ^ b; // propagate
    assign g = a & b; // generate

    assign c[0] = 0; // Initial carry-in is 0
    genvar i;

    generate
        for (i = 0; i < N; i = i + 1) begin : carry_gen
            assign c[i + 1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign sum = p ^ c[N-1:0];
    assign carry_out = c[N];

endmodule
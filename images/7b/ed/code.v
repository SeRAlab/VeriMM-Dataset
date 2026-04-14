module carry_lookahead_adder(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
    );

    wire [15:0] p, g, c;

    assign p = a ^ b; // propagate
    assign g = a & b; // generate

    assign c[0] = cin;
    generate
        genvar i;
        for (i = 0; i < 15; i = i + 1) begin: carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign sum = p ^ c;
    assign cout = g[15] | (p[15] & c[15]);

endmodule
module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);wire [31:0] carry;
    wire [31:0] xor_b;
    wire [31:0] and_b;

    assign xor_b = sub ? ~b : b;
    assign and_b = sub ? ~b : 32'hffffffff;

    generate
        genvar i;
        for (i = 0; i < 32; i = i + 4) begin : carry_lookahead
            wire [3:0] g = {and_b[i+3], and_b[i+2], and_b[i+1], and_b[i]};
            wire [3:0] p = {xor_b[i+3], xor_b[i+2], xor_b[i+1], xor_b[i]};
            wire [3:0] c = {carry[i+3], carry[i+2], carry[i+1], carry[i]};
            wire [3:0] g0 = g & c;
            wire [3:0] p0 = g ^ c;
            wire [3:0] g1 = p & p0;
            wire [3:0] c1 = g1 | g0;
            wire [3:0] p1 = p ^ p0;
            assign carry[i+3] = c1[3];
            assign carry[i+2] = c1[2];
            assign carry[i+1] = c1[1];
            assign carry[i] = c1[0];
            assign sum[i+3] = p1[3];
            assign sum[i+2] = p1[2];
            assign sum[i+1] = p1[1];
            assign sum[i] = p1[0];
        end
    endgenerate

endmodule
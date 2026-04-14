module top_module(
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] result,
    output cout
);wire [15:0] g;
    wire [15:0] p;
    wire [15:0] c;
    wire [15:0] s;

    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign c[0] = g[0] | (p[0] & cin);
    assign s[0] = p[0] ^ cin;

    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : CLA_block
            wire [3:0] a_i = a[4*i +: 4];
            wire [3:0] b_i = b[4*i +: 4];
            wire c_in = c[i-1];

            wire g_i;
            wire p_i;
            wire c_i;
            wire s_i;

            assign g_i = a_i & b_i;
            assign p_i = a_i ^ b_i;
            assign c_i = g_i | (p_i & c_in);
            assign s_i = p_i ^ c_in;

            assign g[i] = g_i;
            assign p[i] = p_i;
            assign c[i] = c_i;
            assign s[i*4 +: 4] = s_i;
        end

        assign result = {s[63:48], s[47:32], s[31:16], s[15:0]};
        assign cout = c[15];
    endgenerate

endmodule
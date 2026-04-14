module quarter_round(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    output [31:0] out_a,
    output [31:0] out_b,
    output [31:0] out_c,
    output [31:0] out_d
);
    wire [31:0] a1, b1, c1, d1;
    wire [31:0] tmp_a, tmp_b, tmp_c, tmp_d;

    assign a1 = a + b;
    assign tmp_d = d ^ a1;
    assign d1 = {tmp_d[27:0], tmp_d[31:28]}; // d <<< 16

    assign c1 = c + d1;
    assign tmp_b = b ^ c1;
    assign b1 = {tmp_b[19:0], tmp_b[31:20]}; // b <<< 12

    assign out_a = a1 + b1;
    assign tmp_d = d1 ^ out_a;
    assign out_d = {tmp_d[24:0], tmp_d[31:25]}; // d <<< 8

    assign c1 = c1 + out_d;
    assign tmp_b = b1 ^ c1;
    assign out_b = {tmp_b[25:0], tmp_b[31:26]}; // b <<< 7

    assign out_c = c1;

endmodule
module chacha20_qr (
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    output reg [31:0] out_a,
    output reg [31:0] out_b,
    output reg [31:0] out_c,
    output reg [31:0] out_d
);

    reg [31:0] a_reg, b_reg, c_reg, d_reg;

    always @(*) begin
        a_reg = a;
        b_reg = b;
        c_reg = c;
        d_reg = d;

        // Round 1
        a_reg = a_reg + b_reg;
        d_reg = d_reg ^ a_reg;
        d_reg = {d_reg[15:0], d_reg[31:16]}; // Rotate left 16

        c_reg = c_reg + d_reg;
        b_reg = b_reg ^ c_reg;
        b_reg = {b_reg[19:0], b_reg[31:20]}; // Rotate left 12

        // Round 2
        a_reg = a_reg + b_reg;
        d_reg = d_reg ^ a_reg;
        d_reg = {d_reg[7:0], d_reg[31:8]}; // Rotate left 8

        c_reg = c_reg + d_reg;
        b_reg = b_reg ^ c_reg;
        b_reg = {b_reg[26:0], b_reg[31:27]}; // Rotate left 7

        out_a = a_reg;
        out_b = b_reg;
        out_c = c_reg;
        out_d = d_reg;
    end
endmodule
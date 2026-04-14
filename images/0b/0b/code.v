module chacha20_quarter_round(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    output reg [31:0] out_a,
    output reg [31:0] out_b,
    output reg [31:0] out_c,
    output reg [31:0] out_d
);
    always @(*) begin
        // ChaCha20 quarter round operation
        out_a = a + b; out_d = (out_a ^ d) <<< 16;
        out_c = c + out_d; out_b = (out_c ^ b) <<< 12;
        out_a = out_a + out_b; out_d = (out_a ^ out_d) <<< 8;
        out_c = out_c + out_d; out_b = (out_c ^ out_b) <<< 7;
    end
endmodule
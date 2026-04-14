module chacha_quarter_round (
    input clk,
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    output reg [31:0] out_a,
    output reg [31:0] out_b,
    output reg [31:0] out_c,
    output reg [31:0] out_d
);
    
    always @(posedge clk) begin
        out_a <= a + b; // a = a + b
        out_d <= d ^ out_a; // d = d ^ a
        out_c <= c + out_d; // c = c + d
        out_b <= b ^ out_c; // b = b ^ c
    end
endmodule
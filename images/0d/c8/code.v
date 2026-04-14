module chacha_quarter_round (
    input clk,
    input [31:0] x0,
    input [31:0] x1,
    input [31:0] x2,
    input [31:0] x3,
    output reg [31:0] out0,
    output reg [31:0] out1,
    output reg [31:0] out2,
    output reg [31:0] out3
);
    reg [31:0] a, b, c, d;

    always @(posedge clk) begin
        // Copy inputs to internal registers
        a <= x0;
        b <= x1;
        c <= x2;
        d <= x3;

        // Quarter round operations
        a <= a + b; 
        d <= (d ^ a) << 16 | (d ^ a) >> (32 - 16);
        c <= c + d; 
        b <= (b ^ c) << 12 | (b ^ c) >> (32 - 12);
        a <= a + b; 
        d <= (d ^ a) << 8 | (d ^ a) >> (32 - 8);
        c <= c + d; 
        b <= (b ^ c) << 7 | (b ^ c) >> (32 - 7);

        // Assign outputs
        out0 <= a;
        out1 <= b;
        out2 <= c;
        out3 <= d;
    end
endmodule
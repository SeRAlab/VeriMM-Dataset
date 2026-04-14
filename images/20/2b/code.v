module chacha_quarter_round (
    input wire clk,
    input wire [31:0] a_in,
    input wire [31:0] b_in,
    input wire [31:0] c_in,
    input wire [31:0] d_in,
    output reg [31:0] a_out,
    output reg [31:0] b_out,
    output reg [31:0] c_out,
    output reg [31:0] d_out
);

reg [31:0] a, b, c, d;

always @(posedge clk) begin
    a <= a_in;
    b <= b_in;
    c <= c_in;
    d <= d_in;

    a <= a + b;
    d <= d ^ a;
    d <= d << 16;

    c <= c + d;
    b <= b ^ c;
    b <= b << 12;

    a <= a + b;
    d <= d ^ a;
    d <= d << 8;

    c <= c + d;
    b <= b ^ c;
    b <= b << 7;

    a_out <= a;
    b_out <= b;
    c_out <= c;
    d_out <= d;
end

endmodule
module quarter_round (
    input clk,
    input rst_n,
    input [31:0] a_in,
    input [31:0] b_in,
    input [31:0] c_in,
    input [31:0] d_in,
    output reg [31:0] a_out,
    output reg [31:0] b_out,
    output reg [31:0] c_out,
    output reg [31:0] d_out
);
    
    reg [31:0] a, b, c, d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a <= 32'b0;
            b <= 32'b0;
            c <= 32'b0;
            d <= 32'b0;
            a_out <= 32'b0;
            b_out <= 32'b0;
            c_out <= 32'b0;
            d_out <= 32'b0;
        end else begin
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
    end
endmodule
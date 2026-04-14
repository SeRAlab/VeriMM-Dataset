module quarter_round (
    input clk,
    input rst,
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
    
    function [31:0] rotate;
        input [31:0] value;
        input [5:0] shift;
        begin
            rotate = (value << shift) | (value >> (32 - shift));
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_out <= 32'b0;
            b_out <= 32'b0;
            c_out <= 32'b0;
            d_out <= 32'b0;
        end else begin
            a = a_in;
            b = b_in;
            c = c_in;
            d = d_in;
            
            a = a + b;
            d = d ^ a;
            d = rotate(d, 16);
            c = c + d;
            b = b ^ c;
            b = rotate(b, 12);
            a = a + b;
            d = d ^ a;
            d = rotate(d, 8);
            c = c + d;
            b = b ^ c;
            b = rotate(b, 7);
            
            a_out <= a;
            b_out <= b;
            c_out <= c;
            d_out <= d;
        end
    end
endmodule
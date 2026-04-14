module quarter_round (
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    output reg [31:0] out_a,
    output reg [31:0] out_b,
    output reg [31:0] out_c,
    output reg [31:0] out_d,
    input clk,
    input rst
);
    reg [31:0] tmp_a, tmp_b, tmp_c, tmp_d;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_a <= 32'h0;
            out_b <= 32'h0;
            out_c <= 32'h0;
            out_d <= 32'h0;
        end else begin
            // Quarter round operation
            tmp_a = a + b;
            tmp_d = d ^ (tmp_a << 16);
            tmp_c = c + tmp_d;
            tmp_b = b ^ (tmp_c << 12);
            tmp_a = tmp_a + tmp_b;
            tmp_d = tmp_d ^ (tmp_a << 8);
            tmp_c = tmp_c + tmp_d;
            tmp_b = tmp_b ^ (tmp_c << 7);
            // Assign outputs
            out_a <= tmp_a;
            out_b <= tmp_b;
            out_c <= tmp_c;
            out_d <= tmp_d;
        end
    end
endmodule
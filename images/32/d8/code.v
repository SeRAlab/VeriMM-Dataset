module quarter_round (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    output wire [31:0] a_out,
    output wire [31:0] b_out,
    output wire [31:0] c_out,
    output wire [31:0] d_out
);

    wire [31:0] a_temp, b_temp, c_temp, d_temp;

    assign a_temp = a + b; 
    assign b_temp = (a_temp ^ (b << 16)) | (b_temp >> 16);
    assign c_temp = c + d; 
    assign d_temp = (c_temp ^ (d << 12)) | (d_temp >> 20);
    assign a_out = a_temp;
    assign b_out = b_temp;
    assign c_out = c_temp;
    assign d_out = d_temp;

endmodule
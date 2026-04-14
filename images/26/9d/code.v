module image_convolution(
    input [8:0] img00, input [8:0] img01, input [8:0] img02,
    input [8:0] img10, input [8:0] img11, input [8:0] img12,
    input [8:0] img20, input [8:0] img21, input [8:0] img22,
    input [8:0] kern00, input [8:0] kern01, input [8:0] kern02,
    input [8:0] kern10, input [8:0] kern11, input [8:0] kern12,
    input [8:0] kern20, input [8:0] kern21, input [8:0] kern22,
    output reg [15:0] conv_out
);
    
always @(*) begin
    conv_out = 
        img00 * kern00 + img01 * kern01 + img02 * kern02 +
        img10 * kern10 + img11 * kern11 + img12 * kern12 +
        img20 * kern20 + img21 * kern21 + img22 * kern22;
end

endmodule
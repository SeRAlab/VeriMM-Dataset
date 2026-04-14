module morphological_dilation (
    input [8:0] img_in, // 3x3 binary input image
    output reg out // Dilation output
);
    always @(*) begin
        out = (img_in[0] | img_in[1] | img_in[2] |
               img_in[3] | img_in[4] | img_in[5] |
               img_in[6] | img_in[7] | img_in[8]);
    end
endmodule
module morphological_dilation (
    input [8:0] image, // 3x3 matrix represented as a 9-bit input
    output reg dilated // single output to indicate dilation result
);
    always @(*) begin
        dilated = |image; // Dilation operation: logical OR of all pixels
    end
endmodule
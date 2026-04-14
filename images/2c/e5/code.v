module morphological_dilation(
    input [8:0] img_in,  // 3x3 matrix flattened
    output reg img_out   // single output for dilation result
);
    always @(*) begin
        img_out = |img_in;  // Dilation: output is 1 if any input is 1
    end
endmodule
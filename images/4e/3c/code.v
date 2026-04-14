module binary_decoder_2to4 (
    input en,
    input [1:0] bin_in,
    output reg [3:0] one_hot_out
);

always @(*) begin
    if (!en) begin
        one_hot_out = 4'b0;
    end else begin
        one_hot_out = 4'b0;
        one_hot_out[bin_in] = 1'b1;
    end
end

endmodule
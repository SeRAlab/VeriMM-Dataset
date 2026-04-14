module binary_decoder_5to32 (
    input en,
    input [4:0] bin_in,
    output reg [31:0] one_hot_out
);

always @(*) begin
    if (!en) begin
        one_hot_out = 32'b0;
    end else begin
        one_hot_out = 32'b0;
        one_hot_out[bin_in] = 1'b1;
    end
end

endmodule
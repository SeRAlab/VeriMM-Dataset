module binary_decoder_6to64 (
    input en,
    input [5:0] bin_in,
    output reg [63:0] one_hot_out
);

always @(*) begin
    if (!en) begin
        one_hot_out = 64'b0;
    end else begin
        one_hot_out = 64'b0;
        one_hot_out[bin_in] = 1'b1;
    end
end

endmodule
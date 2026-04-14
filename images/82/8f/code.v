module binary_decoder_8to256 (
    input en,
    input [7:0] bin_in,
    output reg [255:0] one_hot_out
);

always @(*) begin
    if (!en) begin
        one_hot_out = 256'b0;
    end else begin
        one_hot_out = 256'b0;
        one_hot_out[bin_in] = 1'b1;
    end
end

endmodule
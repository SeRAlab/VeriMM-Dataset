module binary_decoder_1to2 (
    input en,
    input bin_in,
    output reg [1:0] one_hot_out
);

always @(*) begin
    if (!en) begin
        one_hot_out = 2'b0;
    end else begin
        one_hot_out = 2'b0;
        one_hot_out[bin_in] = 1'b1;
    end
end

endmodule
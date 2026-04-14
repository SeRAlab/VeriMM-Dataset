module binary_decoder_4to16 (
    input en,
    input [3:0] bin_in,
    output reg [15:0] one_hot_out
);

always @(*) begin
    if (!en) begin
        one_hot_out = 16'b0;
    end else begin
        one_hot_out = 16'b0;
        one_hot_out[bin_in] = 1'b1;
    end
end

endmodule
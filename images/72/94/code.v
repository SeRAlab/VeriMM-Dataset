module decoder_5to32_with_enable(
    input  [4:0] data_in,
    input  enable,
    output reg [31:0] data_out
);

always @(*) begin
    if (enable) begin
        data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        data_out[data_in] = 1'b1;
    end else begin
        data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    end
end

endmodule
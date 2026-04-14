module decoder_3to8_with_enable(
    input  [2:0] data_in,
    input  enable,
    output reg [7:0] data_out
);

always @(*) begin
    if (enable) begin
        data_out = 8'b0000_0000;
        data_out[data_in] = 1'b1;
    end else begin
        data_out = 8'b0000_0000;
    end
end

endmodule
module decoder_2to4_with_enable(
    input [1:0] data_in,
    input enable,
    output reg [3:0] data_out
);

always @(*) begin
    if (enable) begin
        data_out = 4'b0000;
        data_out[data_in] = 1'b1;
    end else begin
        data_out = 4'b0000;
    end
end

endmodule
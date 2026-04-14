module decoder_1to2_with_enable(
    input  data_in,
    input  enable,
    output reg [1:0] data_out
);

always @(*) begin
    if (enable) begin
        data_out = 2'b00;
        data_out[data_in] = 1'b1;
    end else begin
        data_out = 2'b00;
    end
end

endmodule
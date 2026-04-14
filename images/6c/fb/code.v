module decoder_3to8(
    input  [2:0] data_in,
    output reg [7:0] data_out
);

always @(*) begin
    data_out = 8'b0;
    data_out[data_in] = 1'b1;
end

endmodule
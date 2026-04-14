module decoder_2to4(
    input [1:0] data_in,
    output reg [3:0] data_out
);

always @(*) begin
    data_out = 4'b0;
    data_out[data_in] = 1'b1;
end

endmodule
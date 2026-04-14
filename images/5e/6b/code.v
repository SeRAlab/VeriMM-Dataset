module decoder_4to16(
    input  [3:0] data_in,
    output reg [15:0] data_out
);

always @(*) begin
    data_out = 16'b0;
    data_out[data_in] = 1'b1;
end

endmodule
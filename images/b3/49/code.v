module decoder_6to64(
    input  [5:0] data_in,
    output reg [63:0] data_out
);

always @(*) begin
    data_out = 64'b0;
    data_out[data_in] = 1'b1;
end

endmodule
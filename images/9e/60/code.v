module decoder_8to256(
    input  [7:0] data_in,
    output reg [255:0] data_out
);

always @(*) begin
    data_out = 256'b0;
    data_out[data_in] = 1'b1;
end

endmodule
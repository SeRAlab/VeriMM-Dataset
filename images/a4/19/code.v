module decoder_6to64_with_enable(
    input  [5:0] data_in,
    input  enable,
    output reg [63:0] data_out
);

always @(*) begin
    if (enable) begin
        data_out = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
        data_out[data_in] = 1'b1;
    end else begin
        data_out = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
    end
end

endmodule
module decoder_3to8(
    input [2:0] binary_in,
    output reg [7:0] one_hot_out
);
    always @(*) begin
        one_hot_out = 8'b00000001 << binary_in;
    end
endmodule
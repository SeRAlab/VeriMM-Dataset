module decoder_3to8(
    input wire enable,
    input wire [2:0] binary_in,
    output reg [7:0] decoded_out
    );

always @(*) begin
    if (enable)
        decoded_out = 8'b00000001 << binary_in;
    else
        decoded_out = 8'b00000000;
end

endmodule
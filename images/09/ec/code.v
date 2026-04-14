module DAC_24_to_8 (
    input [23:0] data_in,
    output reg [7:0] data_out
);

always @(*) begin
    data_out = data_in >> 8; // Divide by 256 (2^8) to get 8-bit output
end

endmodule
module bin2_to_4dec(
    input [1:0] bin_in,
    input enable,
    output reg [3:0] dec_out
);

always @(*) begin
    if (enable) begin
        case(bin_in)
            2'b00: dec_out = 4'b0001; // 0
            2'b01: dec_out = 4'b0010; // 1
            2'b10: dec_out = 4'b0100; // 2
            2'b11: dec_out = 4'b1000; // 3
            default: dec_out = 4'b0000; // None
        endcase
    end else begin
        dec_out = 4'b0000; // Disabled
    end
end

endmodule
module bin4_to_bcd(
    input [3:0] bin_in,
    output reg [7:0] bcd_out
);

always @(*) begin
    case(bin_in)
        4'b0000: bcd_out = 8'b0000_0000; // 0
        4'b0001: bcd_out = 8'b0000_0001; // 1
        4'b0010: bcd_out = 8'b0000_0010; // 2
        4'b0011: bcd_out = 8'b0000_0011; // 3
        4'b0100: bcd_out = 8'b0000_0100; // 4
        4'b0101: bcd_out = 8'b0000_0101; // 5
        4'b0110: bcd_out = 8'b0000_0110; // 6
        4'b0111: bcd_out = 8'b0000_0111; // 7
        4'b1000: bcd_out = 8'b0000_1000; // 8
        4'b1001: bcd_out = 8'b0000_1001; // 9
        4'b1010: bcd_out = 8'b0001_0000; // 10
        4'b1011: bcd_out = 8'b0001_0001; // 11
        4'b1100: bcd_out = 8'b0001_0010; // 12
        4'b1101: bcd_out = 8'b0001_0011; // 13
        4'b1110: bcd_out = 8'b0001_0100; // 14
        4'b1111: bcd_out = 8'b0001_0101; // 15
        default: bcd_out = 8'b0000_0000; // Default case (never reached)
    endcase
end

endmodule
module binary_to_7seg (
    input [2:0] binary_in,
    output reg [6:0] seg
);

always @(*) begin
    case (binary_in)
        3'b000: seg = 7'b1111110; // 0
        3'b001: seg = 7'b0110000; // 1
        3'b010: seg = 7'b1101101; // 2
        3'b011: seg = 7'b1111001; // 3
        3'b100: seg = 7'b0110011; // 4
        3'b101: seg = 7'b1011011; // 5
        3'b110: seg = 7'b1011111; // 6
        3'b111: seg = 7'b1110000; // 7
        default: seg = 7'b0000000; // off
    endcase
end

endmodule
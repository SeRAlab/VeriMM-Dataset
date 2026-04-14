module wifi_signal_indicator (
    input [4:0] signal_strength,
    output reg [2:0] strength_level
);
    always @(*) begin
        case (signal_strength)
            5'b00000, 5'b00001, 5'b00010, 5'b00011: strength_level = 3'b000; // Weak
            5'b00100, 5'b00101, 5'b00110: strength_level = 3'b001; // Moderate
            5'b00111, 5'b01000, 5'b01001, 5'b01010, 5'b01011: strength_level = 3'b010; // Good
            5'b01100, 5'b01101, 5'b01110, 5'b01111: strength_level = 3'b011; // Strong
            default: strength_level = 3'b100; // Very Strong
        endcase
    end
endmodule
module wifi_signal_decoder (
    input [4:0] signal_strength,
    output reg [2:0] signal_quality
);
    
    always @(*) begin
        case(signal_strength)
            5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100: signal_quality = 3'b000; // Very Weak
            5'b00101, 5'b00110, 5'b00111, 5'b01000, 5'b01001, 5'b01010: signal_quality = 3'b001; // Weak
            5'b01011, 5'b01100, 5'b01101, 5'b01110, 5'b01111: signal_quality = 3'b010; // Fair
            5'b10000, 5'b10001, 5'b10010, 5'b10011, 5'b10100: signal_quality = 3'b011; // Good
            5'b10101, 5'b10110, 5'b10111, 5'b11000, 5'b11001: signal_quality = 3'b100; // Very Good
            5'b11010, 5'b11011, 5'b11100, 5'b11101, 5'b11110, 5'b11111: signal_quality = 3'b101; // Excellent
            default: signal_quality = 3'b000; // Default case
        endcase
    end
endmodule
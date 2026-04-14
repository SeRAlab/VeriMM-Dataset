module wifi_signal_strength(
    input [3:0] rssi,
    output reg [2:0] strength
);
    always @(rssi) begin
        case (rssi)
            4'b0000: strength = 3'b000; // RSSI < 4
            4'b0001: strength = 3'b000; // RSSI < 4
            4'b0010: strength = 3'b000; // RSSI < 4
            4'b0011: strength = 3'b000; // RSSI < 4
            4'b0100: strength = 3'b001; // 4 <= RSSI < 8
            4'b0101: strength = 3'b001; // 4 <= RSSI < 8
            4'b0110: strength = 3'b001; // 4 <= RSSI < 8
            4'b0111: strength = 3'b001; // 4 <= RSSI < 8
            4'b1000: strength = 3'b010; // 8 <= RSSI < 12
            4'b1001: strength = 3'b010; // 8 <= RSSI < 12
            4'b1010: strength = 3'b010; // 8 <= RSSI < 12
            4'b1011: strength = 3'b010; // 8 <= RSSI < 12
            4'b1100: strength = 3'b011; // 12 <= RSSI < 16
            4'b1101: strength = 3'b011; // 12 <= RSSI < 16
            4'b1110: strength = 3'b011; // 12 <= RSSI < 16
            4'b1111: strength = 3'b100; // RSSI >= 16
            default: strength = 3'b000; // Default case
        endcase
    end
endmodule
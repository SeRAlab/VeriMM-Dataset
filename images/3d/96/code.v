module wifi_status_decoder (
    input [2:0] status,
    output reg [1:0] code
);

always @* begin
    case (status)
        3'b000: code = 2'b00; // Off
        3'b001: code = 2'b01; // Connecting
        3'b010: code = 2'b10; // Connected
        3'b011: code = 2'b11; // Error
        3'b100: code = 2'b11; // Disconnecting
        3'b101: code = 2'b11; // Unknown
        default: code = 2'b00; // Default to Off
    endcase
end

endmodule
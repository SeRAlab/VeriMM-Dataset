module wifi_state_decoder (
    input [1:0] state,
    output reg [2:0] status
);
    always @(*) begin
        case (state)
            2'b00: status = 3'b000; // Disconnected
            2'b01: status = 3'b001; // Connecting
            2'b10: status = 3'b010; // Connected
            2'b11: status = 3'b011; // Error
            default: status = 3'b000; // Default to Disconnected
        endcase
    end
endmodule
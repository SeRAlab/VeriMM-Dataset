module bluetooth_module (
    input [1:0] current_state,
    input connection_request,
    output reg [1:0] next_state
);

always @(*) begin
    case (current_state)
        2'b00: next_state = (connection_request) ? 2'b01 : 2'b00; // Idle
        2'b01: next_state = (connection_request) ? 2'b01 : 2'b10; // Connecting
        2'b10: next_state = (connection_request) ? 2'b00 : 2'b10; // Connected
        default: next_state = 2'b00; // Invalid state
    endcase
end

endmodule
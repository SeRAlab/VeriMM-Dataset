module wifi_controller (
    input clk,
    input [1:0] state,
    output reg connected
);

    always @(posedge clk) begin
        case (state)
            2'b00: connected <= 0;  // Disconnected
            2'b01: connected <= 0;  // Connecting
            2'b10: connected <= 1;  // Connected
            2'b11: connected <= 0;  // Disconnecting
            default: connected <= 0; // Default case
        endcase
    end
endmodule
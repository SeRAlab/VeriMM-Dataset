module wifi_controller(
    input clk,
    input reset,
    input start,
    input connected,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);
    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10, DISCONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connected) state <= CONNECTED;
                    else if (disconnect) state <= CONNECTING; // Stay in CONNECTING
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    if (start) state <= CONNECTING;
                end
                default: state <= IDLE; // Fallback to IDLE
            endcase
        end
    end
endmodule
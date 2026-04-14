module bluetooth_controller(
    input clk,
    input reset,
    input connect,
    input disconnect,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00,
              CONNECTING = 2'b01,
              CONNECTED = 2'b10,
              DISCONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (connect) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connect) state <= CONNECTED; // Successfully connected
                    else if (disconnect) state <= DISCONNECTED; // Failed to connect
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED; // Disconnected
                end
                DISCONNECTED: begin
                    state <= IDLE; // Reset to IDLE after disconnection
                end
            endcase
        end
    end
endmodule
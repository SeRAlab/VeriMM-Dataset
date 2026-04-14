module bluetooth_state_machine (
    input clk,
    input reset,
    input connect,
    input disconnect,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, CONNECTED = 2'b01, DISCONNECTED = 2'b10;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset state to IDLE
        end else begin
            case (state)
                IDLE: begin
                    if (connect) begin
                        state <= CONNECTED; // Transition to CONNECTED
                    end
                end
                CONNECTED: begin
                    if (disconnect) begin
                        state <= DISCONNECTED; // Transition to DISCONNECTED
                    end
                end
                DISCONNECTED: begin
                    if (disconnect) begin
                        state <= IDLE; // Go back to IDLE
                    end
                end
            endcase
        end
    end
endmodule
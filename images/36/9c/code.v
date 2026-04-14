module wifi_sm(
    input clk,
    input reset,
    input start,
    input success,
    output reg [1:0] state // 2 bits to represent the states
);
    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (success) state <= CONNECTED;
                end
                CONNECTED: begin
                    if (!success) state <= IDLE; // Go back to IDLE if not connected
                end
                default: state <= IDLE; // Default to IDLE state
            endcase
        end
    end
endmodule
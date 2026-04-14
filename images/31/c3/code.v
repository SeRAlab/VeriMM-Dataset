module wifi_module (
    input clk,
    input reset,
    input connect,
    input disconnect,
    output reg [1:0] state // 00: DISCONNECTED, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTING
);

    // State definitions
    parameter DISCONNECTED = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTING = 2'b11;

    // State register
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            DISCONNECTED: begin
                if (connect) next_state = CONNECTING;
                else next_state = DISCONNECTED;
            end
            CONNECTING: begin
                next_state = CONNECTED; // Assume we connect instantly for simplicity
            end
            CONNECTED: begin
                if (disconnect) next_state = DISCONNECTING;
                else next_state = CONNECTED;
            end
            DISCONNECTING: begin
                next_state = DISCONNECTED; // Assume we disconnect instantly for simplicity
            end
            default: next_state = DISCONNECTED;
        endcase
    end

    // State update logic
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= DISCONNECTED;
        else 
            current_state <= next_state;
    end

    // Output the current state
    always @(posedge clk) begin
        state <= current_state;
    end

endmodule
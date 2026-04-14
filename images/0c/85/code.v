module bluetooth_module (
    input clk,
    input reset,
    input start,
    input success,
    input fail,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTED = 2'b11;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (success) state <= CONNECTED;
                    else if (fail) state <= IDLE;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    state <= IDLE; // Automatically reset to IDLE
                end
            endcase
        end
    end
endmodule
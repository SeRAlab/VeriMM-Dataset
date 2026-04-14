module wifi_fsm (
    input clk,
    input rst,
    input start,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);
    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10, DISCONNECTED = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONNECTING;
                end
                CONNECTING: begin
                    // Assuming a successful connection is indicated by some signal (not included in inputs for simplicity)
                    state <= CONNECTED; // Transitioning directly for testing purpose
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    if (start) state <= IDLE;
                end
            endcase
        end
    end
endmodule
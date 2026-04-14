module wifi_controller (
    input clk,
    input reset,
    input start_connect,
    input connection_success,
    input disconnect,
    output reg [1:0] current_state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTED = 2'b11;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_connect) begin
                        current_state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    if (connection_success) begin
                        current_state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    if (disconnect) begin
                        current_state <= DISCONNECTED;
                    end
                end
                DISCONNECTED: begin
                    if (start_connect) begin
                        current_state <= CONNECTING;
                    end
                end
            endcase
        end
    end
endmodule
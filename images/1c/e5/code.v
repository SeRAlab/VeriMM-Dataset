module bluetooth_sm (
    input clk,
    input rst_n,
    input start_connection,
    input connection_success,
    input disconnect,
    output reg [1:0] state // 00 = IDLE, 01 = CONNECTING, 10 = CONNECTED, 11 = DISCONNECTED
);

    // State encoding
    parameter IDLE = 2'b00,
              CONNECTING = 2'b01,
              CONNECTED = 2'b10,
              DISCONNECTED = 2'b11;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start_connection) state <= CONNECTING;
                CONNECTING: if (connection_success) state <= CONNECTED;
                            else if (disconnect) state <= DISCONNECTED;
                CONNECTED: if (disconnect) state <= DISCONNECTED;
                DISCONNECTED: if (start_connection) state <= CONNECTING;
                default: state <= IDLE;
            endcase
        end
    end
endmodule
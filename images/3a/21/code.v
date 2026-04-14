module wifi_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire connected,
    input wire disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);
    // State encoding
    localparam IDLE = 2'b00,
               CONNECTING = 2'b01,
               CONNECTED = 2'b10,
               DISCONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= CONNECTING;
                CONNECTING: if (connected) state <= CONNECTED;
                CONNECTED: if (disconnect) state <= DISCONNECTED;
                DISCONNECTED: if (start) state <= CONNECTING;
                default: state <= IDLE;
            endcase
        end
    end
endmodule
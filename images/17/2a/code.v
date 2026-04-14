module bluetooth_fsm(
    input clk,
    input rst_n,
    input start,
    input connect,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTING
);
    // State definitions
    localparam IDLE = 2'b00;
    localparam CONNECTING = 2'b01;
    localparam CONNECTED = 2'b10;
    localparam DISCONNECTING = 2'b11;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= CONNECTING;
                CONNECTING: if (connect) state <= CONNECTED;
                CONNECTED: if (disconnect) state <= DISCONNECTING;
                DISCONNECTING: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule
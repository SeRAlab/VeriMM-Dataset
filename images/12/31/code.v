module sata_controller (
    input clk,
    input reset,
    input start,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTING
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTING = 2'b11;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONNECTING;
                end
                CONNECTING: begin
                    state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTING;
                end
                DISCONNECTING: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
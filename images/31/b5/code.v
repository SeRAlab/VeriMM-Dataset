module bluetooth_fsm (
    input clk,
    input rst,
    input connect,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTED = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (connect) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (disconnect) state <= IDLE; // If disconnected during connecting
                    else state <= CONNECTED; // Assume connection is successful
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    if (connect) state <= CONNECTING;
                end
                default: state <= IDLE; // Default case for safety
            endcase
        end
    end
endmodule
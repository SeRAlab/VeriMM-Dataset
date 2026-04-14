module bluetooth_controller (
    input clk,
    input reset,
    input start_connection,
    input connection_done,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_connection) begin
                        state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    if (connection_done) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    if (disconnect) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
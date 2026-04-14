module bluetooth_state_machine (
    input clk,
    input reset,
    input connect,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTED, 10: DISCONNECTED
);

    parameter IDLE = 2'b00;
    parameter CONNECTED = 2'b01;
    parameter DISCONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (connect) state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    if (reset) state <= IDLE;
                end
            endcase
        end
    end
endmodule
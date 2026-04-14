module bluetooth_fsm (
    input clk,
    input reset,
    input start,
    input disconnect,
    output reg [1:0] state
);
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (disconnect) state <= IDLE;
                    else state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= IDLE;
                end
            endcase
        end
    end
endmodule
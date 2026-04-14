module bluetooth_fsm (
    input clk,
    input rst,
    input connect,
    input disconnect,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, CONNECTED = 2'b01, DISCONNECTED = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else begin
            case (state)
                IDLE: begin
                    if (connect) state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= IDLE;
                end
                DISCONNECTED: begin
                    if (connect) state <= IDLE;
                end
            endcase
        end
    end
endmodule
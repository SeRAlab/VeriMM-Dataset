module bluetooth_controller(
    input clk,
    input reset,
    input start,
    input disconnect,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= CONNECTING;
                CONNECTING: begin
                    if (start) state <= CONNECTED;
                    else if (disconnect) state <= IDLE;
                end
                CONNECTED: if (disconnect) state <= IDLE;
            endcase
        end
    end

endmodule
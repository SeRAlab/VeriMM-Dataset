module wifi_state_machine (
    input clk,
    input reset,
    input connect,
    input connected,
    input disconnect,
    output reg [1:0] state
);

    parameter DISCONNECTED = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= DISCONNECTED;
        end else begin
            case (state)
                DISCONNECTED: begin
                    if (connect) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connected) state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
            endcase
        end
    end
endmodule
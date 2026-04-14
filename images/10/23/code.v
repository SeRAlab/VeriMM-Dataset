module wifi_fsm (
    input clk,
    input reset,
    input connect,
    input disconnect,
    input connected,
    input disconnected,
    output reg [1:0] state
);
    // State encoding
    parameter DISCONNECTED = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTING = 2'b11;

    // Sequential logic for state transitions
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
                    else if (disconnect) state <= DISCONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTING;
                end
                DISCONNECTING: begin
                    if (disconnected) state <= DISCONNECTED;
                    else if (connect) state <= CONNECTING;
                end
            endcase
        end
    end
endmodule
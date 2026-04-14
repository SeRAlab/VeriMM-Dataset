module wifi_status_controller(
    input clk,
    input rst_n,
    input connect,
    input disconnect,
    output reg [1:0] state // 00: DISCONNECTED, 01: CONNECTING, 10: CONNECTED
);
    
    // State encoding
    parameter DISCONNECTED = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= DISCONNECTED; // Reset to DISCONNECTED
        else begin
            case (state)
                DISCONNECTED: begin
                    if (connect) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (disconnect) state <= DISCONNECTED;
                    else state <= CONNECTED; // Assume connection is successful immediately for this example
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
            endcase
        end
    end
endmodule
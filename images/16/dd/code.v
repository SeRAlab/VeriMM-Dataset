module wifi_module(
    input clk,
    input reset,
    input start,
    input connect,
    input disconnect,
    output reg [2:0] state // 3 bits to represent states
);
    
    // State encoding
    parameter IDLE = 3'b000;
    parameter CONNECTING = 3'b001;
    parameter CONNECTED = 3'b010;
    parameter DISCONNECTING = 3'b011;
    parameter DISCONNECTED = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= CONNECTING;
                CONNECTING: if (connect) state <= CONNECTED;
                CONNECTED: if (disconnect) state <= DISCONNECTING;
                DISCONNECTING: state <= DISCONNECTED;
                DISCONNECTED: state <= IDLE; // Reset to IDLE after disconnect
                default: state <= IDLE;
            endcase
        end
    end
endmodule
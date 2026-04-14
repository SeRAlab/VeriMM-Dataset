module bluetooth_sm (
    input wire clk,
    input wire reset,
    input wire start_connect,
    input wire disconnect,
    output reg [1:0] state // 00 - IDLE, 01 - CONNECTING, 10 - CONNECTED, 11 - DISCONNECTED
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTED = 2'b11;

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_connect) begin
                        state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    state <= CONNECTED; // Assume connection is successful
                end
                CONNECTED: begin
                    if (disconnect) begin
                        state <= DISCONNECTED;
                    end
                end
                DISCONNECTED: begin
                    state <= IDLE; // Return to IDLE after disconnection
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
module wifi_control (
    input wire clk,
    input wire reset,
    input wire start,
    input wire connected,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);

    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10, DISCONNECTED = 2'b11;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    if (connected) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    state <= DISCONNECTED; // Simulate some condition to disconnect
                end
                DISCONNECTED: begin
                    state <= IDLE; // Return to idle after disconnect
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
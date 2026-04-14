module bluetooth_controller(
    input clk,
    input reset,
    input start_connect,
    input connect_success,
    input connect_fail,
    input disconnect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);

    // Define states
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (start_connect) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connect_success) state <= CONNECTED;
                    else if (connect_fail) state <= DISCONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    if (start_connect) state <= CONNECTING; // Can restart connection from DISCONNECTED
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
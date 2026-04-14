module bluetooth_fsm(
    input clk,
    input reset,
    input start_conn,
    input conn_success,
    input disconnect,
    output reg [1:0] current_state
);

    // State definition
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;
    parameter DISCONNECTED = 2'b11;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE; // Go to IDLE state on reset
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_conn) current_state <= CONNECTING;
                end
                CONNECTING: begin
                    if (conn_success) current_state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) current_state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    current_state <= IDLE; // Go back to IDLE state after disconnect
                end
            endcase
        end
    end
endmodule
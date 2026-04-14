module wifi_connection_fsm (
    input clock,
    input reset,
    input start_connection,
    input connection_success,
    output reg [1:0] current_state // 00: IDLE, 01: CONNECTING, 10: CONNECTED
);

    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_connection) 
                        current_state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connection_success) 
                        current_state <= CONNECTED;
                end
                CONNECTED: begin
                    if (~connection_success) 
                        current_state <= IDLE; // Reset to IDLE if connection fails
                end
                default: current_state <= IDLE;
            endcase
        end
    end
endmodule
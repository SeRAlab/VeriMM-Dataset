module sata_controller (
    input wire clk,
    input wire reset,
    input wire start_connection,
    input wire connection_success,
    input wire start_disconnection,
    input wire disconnection_success,
    output reg [1:0] current_state
);

    // State Encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10, DISCONNECTING = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: if (start_connection) current_state <= CONNECTING;
                CONNECTING: if (connection_success) current_state <= CONNECTED;
                CONNECTED: if (start_disconnection) current_state <= DISCONNECTING;
                DISCONNECTING: if (disconnection_success) current_state <= IDLE;
                default: current_state <= IDLE;
            endcase
        end
    end
endmodule
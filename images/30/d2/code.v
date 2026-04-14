module wifi_state_machine (
    input wire clk,
    input wire reset,
    input wire start,
    input wire connection_success,
    output reg [1:0] state
);
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= CONNECTING;
                CONNECTING: if (connection_success) state <= CONNECTED;
                CONNECTED: if (!connection_success) state <= IDLE; // Reset to IDLE on failure
                default: state <= IDLE;
            endcase
        end
    end
endmodule
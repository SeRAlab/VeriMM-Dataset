module wifi_module (
    input wire clk,
    input wire reset,
    input wire start_scan,
    input wire connect,
    input wire connected,
    output reg [1:0] state // 00: IDLE, 01: SCANNING, 10: CONNECTING, 11: CONNECTED
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter SCANNING = 2'b01;
    parameter CONNECTING = 2'b10;
    parameter CONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE
        end else begin
            case (state)
                IDLE: if (start_scan) state <= SCANNING;
                SCANNING: if (connect) state <= CONNECTING;
                CONNECTING: if (connected) state <= CONNECTED;
                CONNECTED: if (reset) state <= IDLE; // Goes back to IDLE on reset
                default: state <= IDLE;
            endcase
        end
    end
endmodule
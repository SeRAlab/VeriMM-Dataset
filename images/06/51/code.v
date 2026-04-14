module wifi_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire connected,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= CONNECTING;
                CONNECTING: if (connected) state <= CONNECTED;
                CONNECTED: if (reset) state <= IDLE; // Can return to IDLE from CONNECTED on reset
            endcase
        end
    end
endmodule
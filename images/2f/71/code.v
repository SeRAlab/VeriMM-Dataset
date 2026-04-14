module bluetooth_fsm (
    input clk,
    input reset,
    input start_connect,
    input confirm_connect,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED
);

    // State definitions
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

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
                    if (confirm_connect) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    // Remain in CONNECTED state
                end
            endcase
        end
    end
endmodule
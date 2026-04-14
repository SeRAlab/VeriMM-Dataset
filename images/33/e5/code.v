module bluetooth_controller (
    input wire clk,
    input wire rst,
    input wire start_scan,
    input wire connect,
    output reg [1:0] state // 00: IDLE, 01: SCANNING, 10: CONNECTED
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter SCANNING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_scan) begin
                        state <= SCANNING;
                    end
                end
                SCANNING: begin
                    if (connect) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    // Stay in CONNECTED state until reset
                end
            endcase
        end
    end
endmodule
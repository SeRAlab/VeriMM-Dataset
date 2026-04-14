module bluetooth_sm (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED
);

    reg [2:0] count; // Counter for CONNECTING state duration

    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CONNECTING;
                        count <= 0; // Reset count when entering CONNECTING
                    end
                end
                CONNECTING: begin
                    count <= count + 1;
                    if (count == 3'd4) begin // After 5 clock cycles (0 to 4)
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    // Remain in CONNECTED state until reset is activated
                end
            endcase
        end
    end
endmodule
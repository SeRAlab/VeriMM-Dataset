module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state;
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            tx <= 1; // Idle state for UART is high
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (enable) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // 1 stop bit, 8 data bits, 1 start bit
                        bit_count <= 0;
                        state <= START;
                        busy <= 1;
                    end
                end
                START: begin
                    tx <= 0; // Start bit
                    state <= DATA;
                end
                DATA: begin
                    if (bit_count < 8) begin
                        tx <= shift_reg[bit_count];
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1; // Stop bit
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
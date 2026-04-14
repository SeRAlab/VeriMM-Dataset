module uart_transmitter (
    input clk,
    input rst,
    input [7:0] data_in,
    input send,
    output reg tx,
    output reg done
);

    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state = IDLE;
    reg [3:0] bit_index = 0;
    reg [7:0] data_buffer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1; // Idle state of tx is high
            done <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send) begin
                        data_buffer <= data_in;
                        tx <= 0; // Start bit
                        state <= START;
                        done <= 0;
                    end
                end
                START: begin
                    // Transmit start bit
                    state <= DATA;
                    bit_index <= 0;
                end
                DATA: begin
                    if (bit_index < 8) begin
                        tx <= data_buffer[bit_index];
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1; // Stop bit
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
module i2c_controller (
    input clk,
    input reset,
    input [7:0] data_in,
    input start,
    output reg scl,
    output reg sda,
    output reg done
);
    reg [3:0] state;
    reg [3:0] bit_cnt;

    parameter IDLE = 4'b0000,
              START = 4'b0001,
              SEND = 4'b0010,
              ACK = 4'b0011,
              STOP = 4'b0100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sda <= 1;
            scl <= 1;
            done <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= START;
                        done <= 0;
                    end
                end
                START: begin
                    sda <= 0; // Start condition
                    state <= SEND;
                end
                SEND: begin
                    sda <= data_in[7 - bit_cnt]; // Send MSB first
                    scl <= 0; // Clock low
                    state <= ACK;
                end
                ACK: begin
                    scl <= 1; // Clock high
                    // Assume ACK received
                    if (bit_cnt == 7) begin
                        state <= STOP;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                        state <= SEND;
                    end
                end
                STOP: begin
                    sda <= 0; // Prepare for stop condition
                    scl <= 1; // Clock high
                    sda <= 1; // Stop condition
                    done <= 1;
                    state <= IDLE;
                    bit_cnt <= 0;
                end
            endcase
        end
    end
endmodule
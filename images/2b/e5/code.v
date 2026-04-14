module i2c_master(
    input clk,
    input rst,
    input start,
    input stop,
    input [7:0] data_in,
    output reg done,
    output reg scl,
    output reg sda
);
    reg [3:0] state;
    reg [7:0] data;
    reg [2:0] bit_index;

    localparam IDLE = 0,
               START = 1,
               SEND = 2,
               STOP = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            scl <= 1;
            sda <= 1;
            done <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        state <= START;
                        sda <= 0; // Send start condition
                    end
                end
                START: begin
                    scl <= 0; // Start clock
                    state <= SEND;
                    data <= data_in; // Load data to be sent
                    bit_index <= 0;
                end
                SEND: begin
                    if (bit_index < 8) begin
                        scl <= 0; // Prepare to send bit
                        sda <= data[7 - bit_index]; // Send MSB first
                        scl <= 1; // Clock high for data
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP; // All bits sent
                    end
                end
                STOP: begin
                    scl <= 0; // Prepare to send stop
                    sda <= 0; // Pull SDA low
                    scl <= 1; // Clock high
                    sda <= 1; // Release SDA
                    done <= 1; // Transmission done
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule
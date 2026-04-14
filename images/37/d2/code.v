module I2C_Master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg scl, // Serial Clock Line
    output reg sda, // Serial Data Line
    output reg done
);
    reg [2:0] state;
    reg [3:0] bit_cnt;

    localparam IDLE = 3'b000,
               START = 3'b001,
               SEND_DATA = 3'b010,
               STOP = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            scl <= 1;
            sda <= 1;
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
                    sda <= 0; // Send start condition
                    state <= SEND_DATA;
                end
                SEND_DATA: begin
                    scl <= 0; // Prepare for data bit
                    sda <= data_in[7 - bit_cnt]; // Send data bit
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    scl <= 0;
                    sda <= 1; // Send stop condition
                    done <= 1;
                    state <= IDLE;
                    bit_cnt <= 0;
                end
            endcase
        end
    end
endmodule
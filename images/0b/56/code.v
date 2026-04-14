module i2c_master (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [6:0] addr,
    input wire [7:0] data,
    output reg scl,
    output reg sda,
    output reg done
);
    reg [3:0] state;
    reg [3:0] bit_cnt;

    localparam IDLE = 4'd0,
               START = 4'd1,
               SEND_ADDR = 4'd2,
               ACK_ADDR = 4'd3,
               SEND_DATA = 4'd4,
               ACK_DATA = 4'd5,
               STOP = 4'd6;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            scl <= 1;
            sda <= 1;
            done <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        state <= START;
                        sda <= 0; // Start condition
                    end
                end
                START: begin
                    scl <= 0;
                    state <= SEND_ADDR;
                    bit_cnt <= 0;
                end
                SEND_ADDR: begin
                    if (bit_cnt < 7) begin
                        sda <= addr[6 - bit_cnt]; // Send address bit
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        sda <= 1; // Release SDA for ACK
                        state <= ACK_ADDR;
                    end
                end
                ACK_ADDR: begin
                    scl <= 1; // Clock for ACK
                    state <= SEND_DATA;
                end
                SEND_DATA: begin
                    if (bit_cnt < 8) begin
                        sda <= data[7 - bit_cnt]; // Send data bit
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        sda <= 1; // Release SDA for ACK
                        state <= ACK_DATA;
                    end
                end
                ACK_DATA: begin
                    scl <= 1; // Clock for ACK
                    state <= STOP;
                end
                STOP: begin
                    sda <= 0; // Prepare for stop condition
                    scl <= 1;
                    sda <= 1; // Stop condition
                    state <= IDLE;
                    done <= 1;
                end
            endcase
        end
    end
endmodule
module i2c_master(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [6:0] slave_addr,
    input wire [7:0] data,
    output reg scl,
    output reg sda,
    output reg done
);
    reg [2:0] state;
    reg [3:0] bit_cnt;

    localparam IDLE = 3'b000,
               START = 3'b001,
               SEND_ADDR = 3'b010,
               SEND_DATA = 3'b011,
               STOP = 3'b100;

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
                    if (start) begin
                        sda <= 0;    // Start condition
                        state <= START;
                    end
                end
                START: begin
                    scl <= 0;
                    state <= SEND_ADDR;
                    bit_cnt <= 0;
                end
                SEND_ADDR: begin
                    sda <= slave_addr[6 - bit_cnt]; // Sending the slave address
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) begin
                        state <= SEND_DATA;
                        bit_cnt <= 0;
                    end
                end
                SEND_DATA: begin
                    sda <= data[7 - bit_cnt]; // Sending the data byte
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 8) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    sda <= 1;    // Stop condition
                    done <= 1;   // Indicate that the operation is done
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
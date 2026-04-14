module i2c_controller (
    input wire start,
    input wire stop,
    input wire clk,
    input wire [4:0] addr,
    output reg sda,
    output reg scl,
    output reg [7:0] data_out
);
    reg [3:0] state;
    reg [2:0] bit_cnt;
    parameter IDLE = 4'b0000,
              START = 4'b0001,
              SEND_ADDR = 4'b0010,
              READ_DATA = 4'b0011,
              STOP = 4'b0100;

    always @(posedge clk or posedge start or posedge stop) begin
        if (start) begin
            state <= START;
            bit_cnt <= 3'b000;
            scl <= 1'b0;
            sda <= 1'b0; // Set SDA low for start condition
        end else if (stop) begin
            state <= IDLE;
            sda <= 1'b1; // Set SDA high for stop condition
        end else begin
            case (state)
                START: begin
                    state <= SEND_ADDR;
                end
                SEND_ADDR: begin
                    if (bit_cnt < 5) begin
                        sda <= addr[4 - bit_cnt]; // Send address bit by bit
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        state <= READ_DATA;
                        bit_cnt <= 3'b000;
                    end
                end
                READ_DATA: begin
                    if (bit_cnt < 8) begin
                        scl <= ~scl; // Toggle clock
                        if (scl) begin
                            data_out[7 - bit_cnt] <= sda; // Read data from SDA
                            bit_cnt <= bit_cnt + 1;
                        end
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    sda <= 1'b1; // Stop condition
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
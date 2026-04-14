module i2c_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire stop,
    input wire [7:0] data_in,
    output reg scl,
    output reg sda,
    output reg busy
);
    reg [3:0] state;
    reg [3:0] bit_cnt;

    parameter IDLE = 4'd0;
    parameter START = 4'd1;
    parameter SEND_BYTE = 4'd2;
    parameter STOP = 4'd3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            scl <= 1;
            sda <= 1;
            busy <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start && !busy) begin
                        busy <= 1;
                        state <= START;
                    end
                end
                START: begin
                    sda <= 0; // Start condition
                    state <= SEND_BYTE;
                end
                SEND_BYTE: begin
                    if (bit_cnt < 8) begin
                        scl <= 0; // Clock low
                        sda <= data_in[7 - bit_cnt]; // Send bit
                        bit_cnt <= bit_cnt + 1;
                        state <= SEND_BYTE;
                    end else begin
                        scl <= 1; // Clock high
                        bit_cnt <= 0;
                        state <= STOP;
                    end
                end
                STOP: begin
                    scl <= 1; // Clock high
                    sda <= 1; // Stop condition
                    busy <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
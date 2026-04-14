module uart_transmitter (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;

    reg [1:0] state;
    reg [3:0] bit_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            busy <= 0;
            tx <= 1; // idle state for UART is high
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    if (enable) begin
                        state <= START;
                        busy <= 1;
                    end
                end
                START: begin
                    tx <= 0; // start bit
                    state <= DATA;
                    bit_cnt <= 0;
                end
                DATA: begin
                    tx <= data_in[bit_cnt]; // send data bits
                    if (bit_cnt == 7) begin
                        state <= STOP;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
                STOP: begin
                    tx <= 1; // stop bit
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
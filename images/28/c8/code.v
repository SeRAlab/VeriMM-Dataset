module uart_transmitter (
    input clk,
    input reset,
    input start,
    input [7:0] data,
    output reg tx
);
    reg [3:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] data_reg;

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1;  // idle state for tx is high
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= START;
                        data_reg <= data;
                        bit_cnt <= 0;
                    end
                end
                START: begin
                    tx <= 0;  // start bit
                    state <= DATA;
                end
                DATA: begin
                    tx <= data_reg[bit_cnt]; // transmit data bit
                    if (bit_cnt < 7)
                        bit_cnt <= bit_cnt + 1;
                    else
                        state <= STOP;
                end
                STOP: begin
                    tx <= 1;  // stop bit
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
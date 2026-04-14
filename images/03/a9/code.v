module uart_tx (
    input clk,
    input [7:0] data,
    input tx_en,
    output reg tx
);
    reg [3:0] state;
    reg [2:0] bit_cnt;
    reg [10:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    parameter IDLE = 4'b0000,
              START = 4'b0001,
              DATA = 4'b0010,
              STOP = 4'b0011;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (tx_en) begin
                    shift_reg <= {1'b1, data, 1'b0}; // Load data with start and stop bits
                    bit_cnt <= 0;
                    state <= START;
                end
            end
            START: begin
                tx <= 1'b0; // Start bit
                state <= DATA;
            end
            DATA: begin
                tx <= shift_reg[bit_cnt]; // Send the current bit
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 8) begin
                    state <= STOP; // After 8 data bits go to STOP
                end
            end
            STOP: begin
                tx <= 1'b1; // Stop bit
                state <= IDLE; // go back to idle state
            end
        endcase
    end
endmodule
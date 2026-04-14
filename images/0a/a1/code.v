module uart_tx(
    input wire clk,
    input wire rst,
    input wire tx_en,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;

    parameter IDLE = 4'b0000,
              START = 4'b0001,
              DATA = 4'b0010,
              STOP = 4'b0011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1;
            busy <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (tx_en) begin
                        shift_reg <= data_in;
                        state <= START;
                        busy <= 1;
                        tx <= 0; // Start bit
                    end
                end
                START: begin
                    state <= DATA;
                end
                DATA: begin
                    if (bit_cnt < 8) begin
                        tx <= shift_reg[bit_cnt];
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        state <= STOP;
                        bit_cnt <= 0;
                    end
                end
                STOP: begin
                    tx <= 1; // Stop bit
                    state <= IDLE;
                    busy <= 0;
                end
            endcase
        end
    end
endmodule
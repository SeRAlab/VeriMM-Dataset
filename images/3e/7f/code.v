module spi_master (
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg sclk,
    output reg mosi,
    output reg cs,
    output reg done
);
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sclk <= 0;
            mosi <= 0;
            cs <= 1;
            done <= 0;
            bit_cnt <= 0;
            shift_reg <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (start) begin
                        cs <= 0; // activate chip select
                        shift_reg <= data_in; // load data
                        bit_cnt <= 8; // prepare to send 8 bits
                        state <= 1;
                    end
                end
                1: begin
                    if (bit_cnt > 0) begin
                        sclk <= ~sclk; // toggle clock
                        if (sclk) begin
                            mosi <= shift_reg[7]; // send MSB first
                            shift_reg <= shift_reg << 1; // shift data left
                            bit_cnt <= bit_cnt - 1; // decrement bit count
                        end
                    end else begin
                        cs <= 1; // deactivate chip select
                        sclk <= 0; // ensure clock is low
                        done <= 1; // set done signal
                        state <= 0; // return to idle
                    end
                end
            endcase
        end
    end
endmodule
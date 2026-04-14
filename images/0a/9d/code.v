module spi_master (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output reg SCK,
    output reg MOSI,
    output reg CS,
    output reg done
);

    reg [2:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_buf;

    localparam IDLE = 3'd0,
               START = 3'd1,
               TRANSFER = 3'd2,
               STOP = 3'd3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SCK <= 0;
            MOSI <= 0;
            CS <= 1;
            done <= 0;
            state <= IDLE;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    CS <= 1;
                    done <= 0;
                    if (start) begin
                        CS <= 0; // Activate chip select
                        data_buf <= data_in;
                        state <= START;
                    end
                end
                START: begin
                    SCK <= 0;
                    bit_cnt <= 7; // Start with the most significant bit
                    state <= TRANSFER;
                end
                TRANSFER: begin
                    MOSI <= data_buf[bit_cnt]; // Send data bit
                    SCK <= 1; // Clock high
                    #5; // Wait for half a clock period
                    SCK <= 0; // Clock low
                    if (bit_cnt == 0) begin
                        state <= STOP; // All bits transmitted
                    end else begin
                        bit_cnt <= bit_cnt - 1; // Move to next bit
                    end
                end
                STOP: begin
                    CS <= 1; // Deactivate chip select
                    done <= 1; // Indicate transmission is done
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule
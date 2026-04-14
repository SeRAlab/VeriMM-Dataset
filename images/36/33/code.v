module spi_master (
    input wire clk,         // System clock
    input wire reset_n,     // Active low reset
    input wire start,       // Start signal for transmission
    input wire [7:0] data_in, // Data to be sent to the slave
    output reg SCK,        // SPI clock output
    output reg MOSI,       // Master Out Slave In
    output reg CS,         // Chip Select
    input wire MISO,       // Master In Slave Out
    output reg [7:0] data_out // Data received from the slave
);

    reg [3:0] bit_cnt;     // Bit counter
    reg [7:0] shift_reg;   // Shift register for data transmission
    reg state;             // FSM state

    localparam IDLE = 1'b0, TRANSFER = 1'b1;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            SCK <= 0;
            MOSI <= 0;
            CS <= 1;
            bit_cnt <= 0;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        CS <= 0;
                        shift_reg <= data_in;
                        bit_cnt <= 8;
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (bit_cnt > 0) begin
                        // Generate clock
                        SCK <= ~SCK;
                        if (SCK) begin
                            // On rising edge, send data
                            MOSI <= shift_reg[7];
                            // Receive data
                            data_out <= {data_out[6:0], MISO};
                            // Shift left
                            shift_reg <= {shift_reg[6:0], 1'b0};
                            bit_cnt <= bit_cnt - 1;
                        end
                    end else begin
                        // End of transfer
                        SCK <= 0;
                        CS <= 1; // Release chip select
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
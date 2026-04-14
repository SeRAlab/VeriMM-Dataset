module spi_controller (
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg SCK,
    output reg CS,
    output reg MOSI
);
    reg [2:0] bit_counter;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SCK <= 0;
            CS <= 1; // CS high when idle
            MOSI <= 0;
            bit_counter <= 0;
            shift_reg <= 0;
        end else begin
            if (start) begin
                CS <= 0; // Activate chip select
                shift_reg <= data_in; // Load data into shift register
                bit_counter <= 7; // Start with the MSB
            end else if (bit_counter < 8) begin
                SCK <= ~SCK; // Toggle SPI clock
                if (SCK) begin
                    MOSI <= shift_reg[bit_counter]; // Output the current bit
                    bit_counter <= bit_counter - 1; // Move to the next bit
                end
            end else if (bit_counter == 8) begin
                CS <= 1; // Deactivate chip select after transmission
            end
        end
    end
endmodule
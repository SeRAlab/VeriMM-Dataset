module spi_controller (
    input clk,       // System clock
    input start,     // Start transmission signal
    input [7:0] data_in, // 8-bit data input
    output reg mosi, // Master Out Slave In
    output reg sck,   // SPI clock output
    output reg done    // Transmission done signal
);
    reg [2:0] bit_cnt; // Bit counter
    reg [7:0] shift_reg; // Shift register for data
    reg state; // State variable

    always @(posedge clk) begin
        if (start) begin
            shift_reg <= data_in; // Load data
            bit_cnt <= 3'b000; // Reset counter
            sck <= 0; // Initialize clock
            done <= 0; // Reset done signal
            state <= 1; // Start the transmission
        end else if (state) begin
            sck <= ~sck; // Toggle clock
            if (sck) begin // On rising edge of SCK
                mosi <= shift_reg[7]; // Output the most significant bit
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                bit_cnt <= bit_cnt + 1; // Increment bit counter
                if (bit_cnt == 3'b111) begin
                    done <= 1; // Set done signal after 8 bits
                    state <= 0; // Stop the transmission
                end
            end
        end
    end
endmodule
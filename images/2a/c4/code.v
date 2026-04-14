module spi_controller (
    input wire clk,        // SPI clock input
    input wire cs,         // Chip select input
    input wire [7:0] data, // Data to send
    output reg mosi        // Master out slave in
);
    reg [3:0] bit_count;   // To count the bits sent
    reg [7:0] shift_reg;   // Shift register for data

    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            bit_count <= 0;         // Reset bit counter
            shift_reg <= data;      // Load data into shift register
        end else if (bit_count < 8) begin
            mosi <= shift_reg[7];   // Output the MSB to MOSI
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_count <= bit_count + 1; // Increment bit counter
        end else begin
            mosi <= 1'bz; // High-impedance when done
        end
    end
endmodule
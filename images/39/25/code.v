module spi_master(
    input wire clk,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg sclk,
    output reg cs
);
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (start) begin
            cs <= 0; // Activate chip select
            data_reg <= data_in; // Load data
            bit_count <= 7; // Start with the highest bit
        end else if (bit_count >= 0) begin
            sclk <= 1; // Set clock high
            mosi <= data_reg[bit_count]; // Shift out the bit
            sclk <= 0; // Set clock low
            bit_count <= bit_count - 1; // Move to the next bit
        end else begin
            cs <= 1; // Deactivate chip select after transmission
        end
    end
endmodule
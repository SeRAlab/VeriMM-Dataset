module spi_master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg sclk,
    output reg cs,
    output reg done
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 0;
            sclk <= 0;
            cs <= 1; // Chip select inactive
            done <= 0;
            bit_count <= 0;
        end else begin
            if (start) begin
                cs <= 0; // Activate chip select
                shift_reg <= data_in; // Load data to shift register
                bit_count <= 7; // Start with the most significant bit
                done <= 0;
            end else if (!done) begin
                if (bit_count >= 0) begin
                    sclk <= ~sclk; // Toggle clock
                    if (sclk) begin
                        mosi <= shift_reg[bit_count]; // Send bit
                        bit_count <= bit_count - 1; // Move to next bit
                    end
                end else begin
                    cs <= 1; // Deactivate chip select
                    done <= 1; // Transmission complete
                end
            end
        end
    end
endmodule
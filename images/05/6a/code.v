module spi_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg sclk,
    output reg done
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 0;
            sclk <= 0;
            done <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else if (start && !done) begin
            shift_reg <= data_in;
            bit_count <= 7;
            done <= 0;
        end else if (bit_count < 8) begin
            sclk <= ~sclk; // Toggle clock signal
            if (sclk) begin
                mosi <= shift_reg[bit_count]; // Send the current bit
                bit_count <= bit_count - 1; // Move to the next bit
            end
            if (bit_count == 0) begin
                done <= 1; // Transmission complete
            end
        end
    end
endmodule
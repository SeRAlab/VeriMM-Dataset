module spi_controller(
    input wire clk,
    input wire reset,
    input wire mosi,
    input wire enable,
    output reg miso,
    output reg [7:0] data_out
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            shift_reg <= 8'b00000000;
            miso <= 1'b0;
        end else if (enable) begin
            shift_reg <= {shift_reg[6:0], mosi}; // Shift in MOSI
            bit_count <= bit_count + 1'b1;
            if (bit_count == 3'b111) begin
                data_out <= shift_reg; // Output the received data
                miso <= shift_reg[7]; // Prepare MISO for the next transmission
                bit_count <= 3'b000; // Reset count for the next transmission
            end
        end
    end
endmodule
module spi_controller (
    input wire clk,
    input wire reset,
    input wire SCK,
    input wire CS,
    input wire MOSI,
    output reg MISO
);
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            MISO <= 1'b0;
        end else if (!CS) begin
            // Shift in data on MOSI
            if (SCK) begin
                shift_reg <= {shift_reg[6:0], MOSI};
                bit_count <= bit_count + 1;
                // Send data on MISO after 8 bits are received
                if (bit_count == 3'b111) begin
                    MISO <= shift_reg[7]; // Output the most significant bit
                end
            end
        end else begin
            // Reset state when CS is high
            bit_count <= 3'b0;
            MISO <= 1'b0;
        end
    end
endmodule
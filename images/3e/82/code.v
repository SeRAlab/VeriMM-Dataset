module spi_controller (
    input wire clk,
    input wire cs,
    input wire mosi,
    output reg [7:0] data_out,
    output reg data_ready
);
    reg [2:0] bit_count; // 3 bits for 8 bits
    reg [7:0] shift_reg;

    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            // Reset on chip select going low
            bit_count <= 0;
            shift_reg <= 0;
            data_ready <= 0;
        end else begin
            // Shift data in on the clock edges
            if (bit_count < 8) begin
                shift_reg <= {shift_reg[6:0], mosi}; // Shift left and add new bit
                bit_count <= bit_count + 1;
            end
            if (bit_count == 7) begin
                data_out <= shift_reg; // Output result after last bit
                data_ready <= 1; // Indicate data is ready
            end
        end
    end
endmodule
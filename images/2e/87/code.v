module spi_controller(
    input clk,
    input cs_n,
    input mosi,
    output reg [7:0] data_out
);
    reg [7:0] shift_reg;
    integer bit_count;

    always @(posedge clk or negedge cs_n) begin
        if (!cs_n) begin
            // Reset on chip select inactive
            bit_count <= 0;
            shift_reg <= 8'b0;
        end else if (bit_count < 8) begin
            // Shift in data on falling edge of clk when cs_n is active
            shift_reg <= {shift_reg[6:0], mosi};
            bit_count <= bit_count + 1;
        end
    end

    always @(posedge clk) begin
        if (bit_count == 8) begin
            // Output the complete byte when 8 bits are received
            data_out <= shift_reg;
        end
    end
endmodule
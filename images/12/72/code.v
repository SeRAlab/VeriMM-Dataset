module spi_controller (
    input wire clk,
    input wire cs,
    input wire mosi,
    output reg miso,
    output reg state // 0: idle, 1: transmitting
);

    reg [7:0] shift_reg;
    integer bit_count;

    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            // Reset on chip select low
            state <= 1;
            bit_count <= 0;
            shift_reg <= 8'b0;
            miso <= 0;
        end else begin
            if (state) begin
                // Shift in data on rising edge of clk
                shift_reg <= {shift_reg[6:0], mosi};
                if (bit_count < 8) begin
                    bit_count <= bit_count + 1;
                end else begin
                    // After 8 bits, echo the data back
                    miso <= shift_reg[7];
                    state <= 0; // Go back to idle
                end
            end
        end
    end
endmodule
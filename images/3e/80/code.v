module spi_controller (
    input clk,
    input reset,
    input mosi,
    input ss,
    output reg [7:0] data_out,
    output reg data_ready
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            shift_reg <= 8'b00000000;
            data_ready <= 1'b0;
        end else begin
            if (!ss) begin
                // Shift in data on rising edge of clock
                shift_reg <= {shift_reg[6:0], mosi};
                bit_count <= bit_count + 1;

                if (bit_count == 3'b111) begin
                    data_out <= shift_reg; // Store the received data
                    data_ready <= 1'b1; // Assert data_ready
                end else begin
                    data_ready <= 1'b0; // Clear data_ready if not yet 8 bits
                end
            end else begin
                // If SS is high, reset the bit counter and data_ready
                bit_count <= 3'b000;
                data_ready <= 1'b0;
            end
        end
    end
endmodule
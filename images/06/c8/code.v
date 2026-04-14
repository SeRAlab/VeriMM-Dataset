module spi_controller (
    input clk,
    input reset,
    input cs,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg ready
);
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 8'b0;
            data_out <= 8'b0;
            ready <= 1'b0;
            bit_count <= 3'b0;
        end else if (!cs) begin
            // Shift data in on the rising edge of the clock
            shift_reg <= {shift_reg[6:0], data_in[7]};
            bit_count <= bit_count + 1;

            // Check if we have received 8 bits
            if (bit_count == 3'b111) begin
                data_out <= shift_reg; // Output the received data
                ready <= 1'b1;         // Indicate that data is ready
                bit_count <= 3'b0;     // Reset bit count
            end
        end else begin
            ready <= 1'b0; // Deassert ready when CS is high
        end
    end
endmodule
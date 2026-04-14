module spi_master(
    input clk,
    input start,
    input [7:0] data_in,
    output reg sck,
    output reg mosi,
    output reg done
);
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    initial begin
        sck = 0;
        done = 0;
        bit_count = 0;
        shift_reg = 0;
    end

    always @(posedge clk) begin
        if (start) begin
            shift_reg <= data_in;
            bit_count <= 0;
            done <= 0;
            sck <= 0;
        end else if (bit_count < 8) begin
            sck <= ~sck; // Toggle clock
            if (sck) begin // On the rising edge of sck
                mosi <= shift_reg[7]; // Send the most significant bit
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                bit_count <= bit_count + 1; // Increment bit count
            end
            if (bit_count == 7 && sck) begin
                done <= 1; // Set done high at the end of transmission
            end
        end
    end
endmodule
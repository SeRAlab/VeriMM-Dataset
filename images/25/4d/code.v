module spi_controller (
    input wire clk,
    input wire cs, // chip select
    input wire [7:0] data_in, // data to send
    output reg mosi, // master out slave in
    output reg done // transmission done
);
    reg [2:0] bit_index; // index to keep track of the bit being sent
    reg [7:0] shift_reg; // shift register for data

    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            // Reset on chip select deactivation
            bit_index <= 3'b000;
            shift_reg <= data_in;
            done <= 1'b0;
        end else begin
            if (bit_index < 3'b100) begin // 8 bits to send
                mosi <= shift_reg[7]; // MSB first
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                bit_index <= bit_index + 1;
            end else begin
                done <= 1'b1; // Signal completion after sending 8 bits
            end
        end
    end
endmodule
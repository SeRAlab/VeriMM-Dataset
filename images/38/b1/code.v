module spi_master(
    input wire clk,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg cs
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg sending;

    always @(posedge clk) begin
        if (start) begin
            cs <= 0; // Assert chip select
            sending <= 1;
            shift_reg <= data_in;
            bit_count <= 0;
        end else if (sending) begin
            mosi <= shift_reg[7]; // Send the most significant bit
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_count <= bit_count + 1;

            if (bit_count == 7) begin
                sending <= 0; // Complete sending
                cs <= 1; // De-assert chip select
            end
        end
    end
endmodule
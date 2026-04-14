module spi_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg cs,
    output reg mosi,
    input wire miso
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cs <= 1;
            mosi <= 0;
            data_out <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else if (start && cs) begin
            cs <= 0;
            shift_reg <= data_in;
            bit_count <= 7; // Start with the highest bit
        end else if (!cs) begin
            mosi <= shift_reg[bit_count]; // Send bit
            data_out[bit_count] <= miso; // Receive bit
            if (bit_count == 0) begin
                cs <= 1; // End communication
            end else begin
                bit_count <= bit_count - 1; // Move to the next bit
            end
        end
    end
endmodule
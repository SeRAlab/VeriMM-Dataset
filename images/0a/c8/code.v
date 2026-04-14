module spi_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg miso,
    output reg mosi,
    output reg ss,
    output reg [7:0] data_out
);
    reg [3:0] bit_counter;
    reg [7:0] shift_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 0;
            miso <= 0;
            ss <= 1; // Assert slave select
            bit_counter <= 0;
            data_out <= 0;
        end else if (start) begin
            ss <= 0; // De-assert slave select
            shift_reg <= data_in;
            bit_counter <= 0;
        end else if (bit_counter < 8) begin
            mosi <= shift_reg[7]; // Send MSB first
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            data_out[bit_counter] <= miso; // Capture incoming bit
            bit_counter <= bit_counter + 1;
        end else begin
            ss <= 1; // Assert slave select after transaction
        end
    end
endmodule
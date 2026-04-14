module serializer (
    input wire clk,
    input wire rst,
    input wire in_en,
    input wire [15:0] data_in,
    output reg data_out,
    output reg valid
);
    reg [3:0] bit_counter; // Count the bits serialized
    reg [15:0] shift_reg;  // Shift register for holding input data

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_counter <= 0;
            valid <= 0;
            data_out <= 0;
            shift_reg <= 0;
        end else if (in_en) begin
            shift_reg <= data_in; // Load data into shift register
            bit_counter <= 0;      // Reset bit counter
        end else if (bit_counter < 16) begin
            data_out <= shift_reg[bit_counter]; // Output the current bit
            valid <= 1; // Output is valid
            bit_counter <= bit_counter + 1; // Increment the bit counter
        end else begin
            valid <= 0; // When all bits are sent, valid is low
        end
    end
endmodule
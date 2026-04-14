module serializer (
    input wire clk,
    input wire reset,
    input wire valid,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_index; // 3 bits can count from 0 to 7
    reg [7:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 3'b000;
            serial_out <= 1'b0;
            data_reg <= 8'b0;
        end else if (valid) begin
            data_reg <= parallel_in; // Load data on valid signal
            bit_index <= 3'b0; // Reset bit index
        end else if (bit_index < 3'b111) begin
            serial_out <= data_reg[7 - bit_index]; // Shift out one bit
            bit_index <= bit_index + 1; // Increment the bit index
        end
    end
endmodule
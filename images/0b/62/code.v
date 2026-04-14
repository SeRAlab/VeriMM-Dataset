module serializer(
    input clk,
    input reset,
    input [7:0] parallel_in,
    input valid,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count from 0 to 7
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            serial_out <= 1'b0;
            shift_reg <= 8'b00000000;
        end else if (valid) begin
            shift_reg <= parallel_in; // Load parallel data
            bit_count <= 3'b000; // Reset bit count
        end else if (bit_count < 3'b111) begin
            serial_out <= shift_reg[7]; // Shift out the MSB
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_count <= bit_count + 1'b1; // Increment bit count
        end else begin
            serial_out <= 1'b0; // Do not output after last bit
        end
    end
endmodule
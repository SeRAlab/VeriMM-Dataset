module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] parallel_in,
    input wire load,
    output reg serial_out
);

reg [2:0] bit_count; // 3 bits to count from 0 to 7
reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_count <= 3'b000;
        serial_out <= 1'b0;
        shift_reg <= 8'b00000000;
    end else if (load) begin
        shift_reg <= parallel_in;
        bit_count <= 3'b000;
    end else if (bit_count < 3'b111) begin
        serial_out <= shift_reg[7]; // Output the MSB first
        shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
        bit_count <= bit_count + 1;
    end else begin
        serial_out <= 1'b0; // After all bits are sent, stay low
    end
end

endmodule
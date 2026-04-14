module serializer (
    input wire clk,
    input wire load,
    input wire [7:0] parallel_in,
    output reg serial_out
);

    reg [2:0] bit_index; // 3 bits to count from 0 to 7

    always @(posedge clk) begin
        if (load) begin
            bit_index <= 3'b111; // Start from the highest bit
        end else if (bit_index != 3'b111) begin
            serial_out <= parallel_in[bit_index]; // Shift out the current bit
            bit_index <= bit_index - 1; // Move to the next bit
        end
    end
endmodule
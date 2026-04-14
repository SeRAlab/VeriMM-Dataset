module deserializer (
    input wire clk,
    input wire enable,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] bit_count; // Counts the number of bits deserialized

    always @(posedge clk) begin
        if (enable) begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift in the new bit
            bit_count <= bit_count + 1; // Increment the bit count
            if (bit_count == 7) begin
                bit_count <= 0; // Reset count after 8 bits
            end
        end
    end
endmodule
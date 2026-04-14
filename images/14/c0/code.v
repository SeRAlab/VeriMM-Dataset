module serializer(
    input wire clk,
    input wire start,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] bit_count; // To count the number of bits serialized

    always @(posedge clk) begin
        if (start) begin
            bit_count <= 3'b000; // Reset the bit count
            serial_out <= parallel_in[7]; // Start with the MSB
            done <= 0; // Serialization not done
        end else if (bit_count < 3'b111) begin
            serial_out <= parallel_in[7 - bit_count]; // Shift out next bit
            bit_count <= bit_count + 1; // Increment bit count
        end else begin
            done <= 1; // Indicate serialization is done
        end
    end
endmodule
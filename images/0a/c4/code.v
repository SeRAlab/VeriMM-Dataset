module serializer(
    input clk,
    input reset,
    input [15:0] parallel_in,
    input start,
    output reg serial_out,
    output reg done
);
    reg [3:0] bit_count;
    reg [15:0] data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serial_out <= 0;
            done <= 0;
            bit_count <= 0;
            data <= 0;
        end else if (start && bit_count == 0) begin
            data <= parallel_in;
            bit_count <= 15; // Start with the highest bit
            done <= 0;
        end else if (bit_count > 0) begin
            serial_out <= data[bit_count];
            bit_count <= bit_count - 1;
        end else if (bit_count == 0) begin
            done <= 1; // Serialization complete
        end
    end
endmodule
module serializer (
    input clk,
    input reset,
    input start,
    input [31:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [4:0] bit_count; // Count from 0 to 31 (32 bits)
    reg [31:0] data; // Store data for serialization

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            serial_out <= 0;
            done <= 0;
            data <= 0;
        end else if (start) begin
            data <= data_in; // Load data on start
            bit_count <= 0; // Reset bit count
            done <= 0; // Clear done signal
        end else if (bit_count < 32) begin
            serial_out <= data[31 - bit_count]; // Output the current bit
            bit_count <= bit_count + 1; // Increment bit count
            if (bit_count == 31) begin
                done <= 1; // Set done signal after sending all bits
            end else begin
                done <= 0; // Clear done signal until finished
            end
        end
    end
endmodule
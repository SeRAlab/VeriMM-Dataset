module serializer (
    input clk,
    input reset,
    input [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] bit_count; // 3 bits to count from 0 to 7
    reg [7:0] data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            data <= 8'b0;
            serial_out <= 1'b0;
            done <= 1'b0;
        end else if (bit_count < 3'd8) begin
            if (bit_count == 3'b000) begin
                data <= parallel_in; // Load data on first clock edge
            end
            serial_out <= data[7 - bit_count]; // Output the bits from MSB to LSB
            bit_count <= bit_count + 1; // Increment bit count
            done <= (bit_count == 3'd7); // Set done when all bits are sent
        end
    end
endmodule
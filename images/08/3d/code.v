module serializer (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [5:0] bit_count;  // 6 bits to count 0-31
    reg [31:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            serial_out <= 0;
            done <= 0;
            shift_reg <= 0;
        end else if (start) begin
            shift_reg <= data_in; // Load data into shift register
            bit_count <= 0;        // Reset bit count
            done <= 0;            // Indicate serialization not done
        end else if (bit_count < 32) begin
            serial_out <= shift_reg[31]; // Output MSB
            shift_reg <= shift_reg << 1; // Shift left
            bit_count <= bit_count + 1;   // Increment bit count
        end else begin
            done <= 1;                    // Serialization done
        end
    end
endmodule
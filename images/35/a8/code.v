module serializer (
    input clk,
    input rst,
    input load,
    input start,
    input [7:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] bit_count; // To count the number of bits serialized
    reg [7:0] shift_reg; // Shift register to hold data

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            shift_reg <= 8'b00000000;
            serial_out <= 1'b0;
            done <= 1'b0;
        end else begin
            if (load) begin
                shift_reg <= data_in; // Load data into the shift register
                bit_count <= 3'b000;   // Reset bit count
                done <= 1'b0;          // Reset done signal
            end else if (start && bit_count < 3'b1000) begin
                serial_out <= shift_reg[7]; // Output the most significant bit
                shift_reg <= shift_reg << 1; // Shift left to prepare the next bit
                bit_count <= bit_count + 1;   // Increment bit count
            end
            
            if (bit_count == 3'b111) begin
                done <= 1'b1; // Set done signal when all bits are serialized
            end
        end
    end
endmodule
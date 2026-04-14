module deserializer(
    input clk,
    input rst,
    input serial_in,
    output reg [7:0] parallel_out,
    output reg valid
);
    reg [2:0] bit_count; // 3 bits to count from 0 to 7
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            shift_reg <= 8'b00000000;
            parallel_out <= 8'b00000000;
            valid <= 0;
        end else begin
            if (bit_count < 3'b111) begin
                shift_reg <= {shift_reg[6:0], serial_in}; // Shift left and add new bit
                bit_count <= bit_count + 1;
                valid <= 0; // Output is not valid until 8 bits are received
            end else begin
                parallel_out <= {shift_reg[6:0], serial_in}; // Output the last shift register value
                valid <= 1; // Mark the output as valid
                bit_count <= 0; // Reset the count for the next byte
                shift_reg <= 8'b00000000; // Reset the shift register
            end
        end
    end
endmodule
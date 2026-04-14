module serializer(
    input wire clk,
    input wire enable,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count up to 8
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (enable) begin
            // Load the parallel input into shift register at the start
            if (bit_count == 3'd0) begin
                shift_reg <= parallel_in;
            end
            
            // Shift out each bit
            serial_out <= shift_reg[7];
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_count <= bit_count + 1'b1; // Increment bit count
            
            // Reset after 8 bits
            if (bit_count == 3'd7) begin
                bit_count <= 3'd0; // Reset bit counter after completing serialization
            end
        end
    end
endmodule
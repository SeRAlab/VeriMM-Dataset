module serializer (
    input clk,
    input reset,
    input start,
    input [7:0] parallel_in,
    output reg serial_out
);

    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 4'b0000;
            serial_out <= 1'b0;
            shift_reg <= 8'b00000000;
        end else if (start) begin
            if (bit_count < 4'b1000) begin
                serial_out <= shift_reg[7];
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                bit_count <= bit_count + 1;
            end else begin
                serial_out <= 1'b0; // Output stable after all bits
                bit_count <= bit_count; // Maintain count
            end
        end else begin
            shift_reg <= parallel_in; // Load new data when start is low
            bit_count <= 4'b0000; // Reset bit count
        end
    end
endmodule
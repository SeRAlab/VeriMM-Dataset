module serializer (
    input clk,
    input enable,
    input [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count 0 to 7 (8 bits)
    
    always @(posedge clk) begin
        if (enable) begin
            if (bit_count < 8) begin
                serial_out <= parallel_in[7 - bit_count];
                bit_count <= bit_count + 1;
            end else begin
                serial_out <= 0; // Output is 0 after all bits are sent
            end
        end else begin
            bit_count <= 0; // Reset bit count when enable is low
            serial_out <= 0; // Output 0 if not enabled
        end
    end
endmodule
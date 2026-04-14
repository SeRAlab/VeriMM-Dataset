module serializer(
    input wire clk,
    input wire enable,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count 0 to 7
    reg [7:0] data;
    
    always @(posedge clk) begin
        if (enable) begin
            data <= parallel_in; // Load data when enabled
            bit_count <= 3'b000;  // Reset bit count
        end else if (bit_count < 3'b111) begin
            serial_out <= data[bit_count]; // Shift out one bit
            bit_count <= bit_count + 1; // Increment bit count
        end
    end
endmodule
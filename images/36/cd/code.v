module serializer(
    input wire clk,
    input wire enable,
    input wire [15:0] parallel_in,
    output reg serial_out
);
    reg [3:0] bit_count; // 4 bits to count 16 shifts

    always @(posedge clk) begin
        if (enable) begin
            if (bit_count < 16) begin
                serial_out <= parallel_in[15 - bit_count]; // Shift out MSB first
                bit_count <= bit_count + 1;
            end else begin
                serial_out <= 1'bz; // High impedance state
            end
        end else begin
            serial_out <= 1'bz; // High impedance when not enabled
            bit_count <= 0; // Reset count when not enabled
        end
    end
endmodule
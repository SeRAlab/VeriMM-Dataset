module serializer (
    input clk,
    input reset,
    input [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count 8 bits (0 to 7)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            serial_out <= 0;
        end else if (bit_count < 8) begin
            serial_out <= parallel_in[bit_count]; // output the current bit
            bit_count <= bit_count + 1; // increment the bit counter
        end else begin
            serial_out <= 0; // after 8 bits, output 0
        end
    end
endmodule
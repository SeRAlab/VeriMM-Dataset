module deserializer (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] bit_count; // 3-bit counter to count bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            parallel_out <= 8'b00000000;
        end else begin
            if (bit_count < 3'b111) begin // less than 8 bits
                parallel_out <= {parallel_out[6:0], serial_in}; // shift in the new bit
                bit_count <= bit_count + 1;
            end else begin
                // Reset for the next byte
                bit_count <= 3'b000;
            end
        end
    end
endmodule
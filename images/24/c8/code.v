module deserializer (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out
);

    integer bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 8'b0;
            bit_count <= 0;
        end else if (bit_count < 8) begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift left and insert new bit
            bit_count <= bit_count + 1;
        end
    end

endmodule
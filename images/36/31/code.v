module deserializer (
    input wire clk,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (bit_count < 8) begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift in the new bit
            bit_count <= bit_count + 1; // Increment bit count
        end
    end

    initial begin
        parallel_out = 8'b0;
        bit_count = 3'b0;
    end
endmodule
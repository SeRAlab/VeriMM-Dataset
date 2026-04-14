module deserializer (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out,
    output reg data_ready
);
    reg [2:0] bit_count; // To count the number of bits received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 8'b0;
            bit_count <= 3'b0;
            data_ready <= 1'b0;
        end else if (bit_count < 3'd8) begin
            parallel_out[bit_count] <= serial_in; // Store the bit
            bit_count <= bit_count + 1; // Increment the bit count
            data_ready <= 1'b0; // Not ready yet
        end else begin
            data_ready <= 1'b1; // Data is ready after 8 bits
        end
    end
endmodule
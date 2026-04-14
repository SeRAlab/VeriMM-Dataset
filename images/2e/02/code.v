module deserializer (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [7:0] parallel_out,
    output reg data_ready
);
    reg [2:0] bit_count; // 3 bits to count 0 to 7

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 0;
            parallel_out <= 8'b0;
            data_ready <= 0;
        end else begin
            if (bit_count < 8) begin
                parallel_out[bit_count] <= serial_in; // Shift in the serial data
                bit_count <= bit_count + 1;
                data_ready <= 0; // Data is not ready until we have 8 bits
            end
            if (bit_count == 7) begin
                data_ready <= 1; // Data is ready after receiving 8 bits
            end
            if (bit_count == 8) begin
                bit_count <= 0; // Reset bit_count for the next byte
            end
        end
    end
endmodule
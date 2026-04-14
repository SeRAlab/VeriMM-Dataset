module deserializer (
    input clk,
    input rst,
    input serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] bit_count; // 3 bits to count 0 to 7

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parallel_out <= 8'b0;
            bit_count <= 3'b0;
        end else begin
            parallel_out <= {parallel_out[6:0], serial_in}; // Shift in new data
            if (bit_count < 3'd7) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0; // Reset count after 8 bits
            end
        end
    end
endmodule
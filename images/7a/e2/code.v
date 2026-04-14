module gray_code_counter_with_enable
(
    input clk,
    input reset,
    input enable,
    output reg [2:0] gray_code
);
    reg [2:0] binary_count;

    always @(posedge clk) begin
        if (reset) begin
            binary_count <= 3'b000; // Clear binary count to 0
        end else if (enable) begin
            binary_count <= binary_count + 1; // Increment binary count
        end
    end

    always @(binary_count) begin
        gray_code = binary_count ^ (binary_count >> 1); // Binary to Gray code conversion
    end

endmodule
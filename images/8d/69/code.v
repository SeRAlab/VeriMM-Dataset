module gray_code_counter
(
    input clk,
    input reset,
    output reg [3:0] gray_code
);
    reg [3:0] binary_count;

    always @(posedge clk) begin
        if (reset) begin
            binary_count <= 4'b0000; // Clear binary count to 0
        end else begin
            binary_count <= binary_count + 1; // Increment binary count
        end
    end

    always @(binary_count) begin
        gray_code = binary_count ^ (binary_count >> 1); // Binary to Gray code conversion
    end

endmodule
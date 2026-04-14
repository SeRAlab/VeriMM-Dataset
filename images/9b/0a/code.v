module gray_code_counter(
    input clk,
    input reset,
    input enable,
    output reg [7:0] count
);

reg [7:0] binary_count;

always @(posedge clk or posedge reset)
    if (reset) begin
        binary_count <= 8'b00000000; // Reset binary count to 0
        count <= 8'b00000000; // Reset Gray code count to 0
    end else if (enable) begin
        binary_count <= binary_count + 1; // Increment binary count
        count <= (binary_count >> 1) ^ binary_count; // Convert to Gray code
    end

endmodule
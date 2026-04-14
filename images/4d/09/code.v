module top_module (
    input clk,
    output reg [3:0] gray_code
);

    reg [3:0] binary_count;

    // 4-bit gray code counter logic
    always @(posedge clk) begin
        binary_count <= binary_count + 1;
        gray_code <= (binary_count >> 1) ^ binary_count;
    end

endmodule
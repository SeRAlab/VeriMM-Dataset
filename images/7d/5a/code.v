module binary_counter
(
    input clk,
    input reset,
    input enable,
    output reg [7:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b0; // Clear counter to 0
        end else if (enable) begin
            count <= count + 1; // Increment counter
        end
    end

endmodule
module counter_with_enable
(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Clear counter to 0
        end else if (enable) begin
            count <= count + 1; // Increment counter if enabled
        end
    end

endmodule
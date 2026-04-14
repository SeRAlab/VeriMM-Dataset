module counter_with_enable
(
    input clk,
    input reset,
    input enable,
    output reg [5:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 6'b000000; // Reset counter to 000000
        end else if (enable) begin
            count <= count + 1; // Increment counter
        end
    end

endmodule
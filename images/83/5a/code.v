module counter(
    input clk,
    input reset_n,
    input enable,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 4'b0000
            count <= 4'b0000;
        end else if (enable) begin
            // Increment operation: Increment counter when enable is high
            count <= count + 1;
        end
    end

endmodule
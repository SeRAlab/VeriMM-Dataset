module counter_with_enable (
    input clk,
    input reset,
    input enable,
    output [3:0] count
);

    reg [3:0] counter_reg;  // 4-bit counter register

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 4'b0000;  // Reset the counter to 0
        end else if (enable) begin
            counter_reg <= counter_reg + 1;  // Increment the counter
        end
    end

    assign count = counter_reg;

endmodule
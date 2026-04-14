module binary_counter_down (
    input clk,
    input reset,
    input enable,
    output [11:0] count
);

    reg [11:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 12'b0;  // Reset the counter to 0
        end else if (enable) begin
            counter_reg <= counter_reg - 1;  // Decrement the counter
        end
    end

    assign count = counter_reg;

endmodule
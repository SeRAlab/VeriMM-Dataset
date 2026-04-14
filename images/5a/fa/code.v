module up_down_counter (
    input clk,
    input reset,
    input direction,
    output [15:0] count
);

    reg [15:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 16'b0;  // Reset the counter to 0
        end else if (direction) begin
            counter_reg <= counter_reg + 1;  // Increment the counter
        end else begin
            counter_reg <= counter_reg - 1;  // Decrement the counter
        end
    end

    assign count = counter_reg;

endmodule
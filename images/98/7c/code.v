module up_down_counter (
    input clk,
    input reset,
    input up,
    output [7:0] count
);

    reg [7:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 8'b00000000;  // Reset the counter to 0
        end else if (up) begin
            counter_reg <= counter_reg + 1;  // Increment the counter
        end else begin
            counter_reg <= counter_reg - 1;  // Decrement the counter
        end
    end

    assign count = counter_reg;

endmodule
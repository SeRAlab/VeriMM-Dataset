module binary_down_counter (
    input clk,
    input reset,
    output [4:0] count
);

    reg [4:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 5'b11111;  // Reset the counter to 31
        end else begin
            counter_reg <= counter_reg - 1;  // Decrement the counter
        end
    end

    assign count = counter_reg;

endmodule
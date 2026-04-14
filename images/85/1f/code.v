module binary_counter_async_reset (
    input clk,
    input async_reset,
    output [3:0] count
);

    reg [3:0] counter_reg;

    always @(posedge clk or posedge async_reset) begin
        if (async_reset) begin
            counter_reg <= 4'b0;  // Asynchronously reset the counter to 0
        end else begin
            counter_reg <= counter_reg + 1;  // Increment the counter
        end
    end

    assign count = counter_reg;

endmodule
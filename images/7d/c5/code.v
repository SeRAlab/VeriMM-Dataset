module binary_up_counter (
    input clk,
    input reset,
    output [2:0] count
);

    reg [2:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 3'b000;  // Reset the counter to 0
        end else begin
            counter_reg <= counter_reg + 1;  // Increment the counter
        end
    end

    assign count = counter_reg;

endmodule
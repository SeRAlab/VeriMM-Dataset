module counter (
    input clk,
    input reset,
    output [1:0] count
);

    reg [1:0] counter_reg;  // 2-bit counter register

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 2'b00;  // Reset the counter to 0
        end else begin
            counter_reg <= counter_reg + 1;  // Increment the counter
        end
    end

    assign count = counter_reg;

endmodule
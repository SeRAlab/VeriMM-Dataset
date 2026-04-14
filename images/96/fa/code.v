module johnson_counter (
    input clk,
    input reset,
    output [3:0] count
);

    reg [3:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 4'b0000;  // Reset the counter to 0
        end else begin
            counter_reg <= {~counter_reg[3], counter_reg[3:1]};  // Shift left and invert MSB
        end
    end

    assign count = counter_reg;

endmodule
module ring_counter (
    input clk,
    input reset,
    output [3:0] count
);

    reg [3:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 4'b1000;  // Reset the counter to 8
        end else begin
            counter_reg <= {counter_reg[2:0], counter_reg[3]};  // Shift left
        end
    end

    assign count = counter_reg;

endmodule
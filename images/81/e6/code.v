module ring_counter (
    input clk,
    input reset,
    output [9:0] count
);

    reg [9:0] counter_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 10'b0000000001;  // Reset the counter to 0000000001
        end else begin
            counter_reg <= {counter_reg[8:0], counter_reg[9]};  // Rotate the bits
        end
    end

    assign count = counter_reg;

endmodule
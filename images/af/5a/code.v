module up_down_counter(
    input clk,
    input reset_n,
    input enable,
    input up_down,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 3'b000
            count <= 3'b000;
        end else if (enable) begin
            // Count operation: Increment or decrement based on up_down signal
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule
module up_counter(
    input clk,
    input enable,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 3'b000; // Reset the counter to zero
        end else if (enable) begin
            q <= q + 1; // Increment the counter
        end
    end

endmodule
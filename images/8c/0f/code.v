module johnson_counter_4bit(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            q <= 4'b0000;
        end else begin
            // Johnson counter: Rotate the bits and complement the new bit
            q <= {q[2:0], ~q[3]};
        end
    end

endmodule
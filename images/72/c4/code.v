module sr_latch(
    input set,
    input reset,
    output reg q
);

    // Always block triggered on changes to the inputs
    always @(*) begin
        if (set && reset) begin
            q = 1'b0;  // Both set and reset high, output is zero
        end else if (set) begin
            q = 1'b1;  // Set output to one
        end else if (reset) begin
            q = 1'b0;  // Reset output to zero
        end
    end

endmodule
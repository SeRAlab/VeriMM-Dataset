module top_module(
    input clk,
    input reset,
    input d,
    output reg q
);

    // Always block triggered on the rising edge of the clock or reset input
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;  // Asynchronous reset to zero
        end else begin
            q <= d;  // Load data into the flip-flop
        end
    end

endmodule
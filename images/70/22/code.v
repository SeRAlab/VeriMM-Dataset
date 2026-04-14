module top_module(
    input d,
    input clk,
    input reset,
    output reg q
);

    // Always block triggered on the rising edge of the clock or the asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0; // Reset the flip-flop to 0
        end else begin
            q <= d; // Transfer the input data to the output
        end
    end

endmodule
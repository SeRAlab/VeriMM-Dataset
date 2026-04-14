module top_module(
    input clk,
    input reset,
    input up_down,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000; // Reset the counter to 0
        end else if (up_down) begin
            q <= q + 1; // Increment the counter
        end else begin
            q <= q - 1; // Decrement the counter
        end
    end

endmodule
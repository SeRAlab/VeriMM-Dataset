module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock or the asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'd0;  // Asynchronous reset to 0
        end else if (enable) begin
            q <= q + 4'd1;  // Increment the counter
        end
    end

endmodule
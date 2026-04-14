module top_module(
    input clk,
    input enable,
    input clear,
    output reg [9:0] q
);

    // Always block triggered on the rising edge of the clock or the rising edge of clear
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            q <= 10'b0;  // Asynchronous clear to zero
        end else if (enable) begin
            q <= q + 1;  // Increment the counter when enabled
        end
    end

endmodule
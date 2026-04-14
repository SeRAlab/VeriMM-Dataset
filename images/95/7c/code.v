module top_module(
    input clk,
    input reset,
    input load,
    input clear,
    input [5:0] load_value,
    output reg [5:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 6'b0;
        end else if (clear) begin
            q <= 6'b0;
        end else if (load) begin
            q <= load_value; // Load the given value
        end else begin
            q <= q + 1'b1; // Increment the counter
        end
    end

endmodule
module top_module(
    input clk,
    input reset_n,
    input enable,
    input load,
    input [7:0] load_value,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock or asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q <= 8'b0; // Reset the counter
        end else if (load) begin
            q <= load_value; // Load the given value
        end else if (enable) begin
            q <= q + 1'b1; // Increment the counter
        end
    end

endmodule
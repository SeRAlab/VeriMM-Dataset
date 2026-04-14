module top_module(
    input clk,
    input reset_n,
    input up_down,
    input load,
    input [4:0] load_value,
    output reg [4:0] q
);

    // Always block triggered on the rising edge of the clock or asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q <= 5'b0; // Reset the counter
        end else if (load) begin
            q <= load_value; // Load the given value
        end else if (up_down) begin
            q <= q + 1'b1; // Increment the counter
        end else begin
            q <= q - 1'b1; // Decrement the counter
        end
    end

endmodule
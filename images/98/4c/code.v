module top_module(
    input clk,
    input reset,
    input load,
    input [15:0] load_value,
    output reg [15:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
        end else if (load) begin
            q <= load_value; // Load the given value
        end else begin
            q <= q - 1'b1; // Decrement the counter
        end
    end

endmodule
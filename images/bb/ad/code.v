module top_module(
    input clk,
    input reset,
    input load,
    input [4:0] data,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 5'b00000
            q <= 5'b00000;
        end else if (load) begin
            // Load the specified value into the counter
            q <= data;
        end else begin
            // Increment the counter
            q <= q + 1;
        end
    end

endmodule
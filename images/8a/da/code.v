module binary_counter_with_load(
    input clk,
    input reset,
    input load,
    input [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            q <= 4'b0000;
        end else if (load) begin
            // Parallel load: Load data into the counter
            q <= data;
        end else begin
            // Increment the counter by 1
            q <= q + 1;
        end
    end

endmodule
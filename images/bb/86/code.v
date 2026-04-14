module top_module(
    input clk,
    input reset_n,
    input load,
    input [5:0] load_val,
    output reg [5:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 6'b000000
            q <= 6'b000000;
        end else if (load) begin
            // Load operation: Load the counter with the provided value
            q <= load_val;
        end else begin
            // Binary counter: Increment by 1
            q <= q + 1;
        end
    end

endmodule
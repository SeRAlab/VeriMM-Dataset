module top_module(
    input clk,
    input reset,
    input load,
    input [4:0] load_val,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 5'b00000
            q <= 5'b00000;
        end else if (load) begin
            // Load operation: Load the counter with the provided value
            q <= load_val;
        end else begin
            // Binary counter: Increment by 1
            q <= q + 1;
        end
    end

endmodule
module top_module(
    input clk,
    input reset_n,
    input load,
    input [3:0] load_val,
    output reg [3:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else if (load) begin
            // Load operation: Load the counter with the provided value
            q <= load_val;
        end else begin
            // Binary counter: Increment by 1
            q <= q + 1;
        end
    end

endmodule
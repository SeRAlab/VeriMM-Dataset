module top_module(
    input clk,
    input reset,
    input load,
    input [4:0] load_val,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00000;  // Synchronous reset to zero
        end else if (load) begin
            q <= load_val;  // Load new value
        end else begin
            q <= q + 1;  // Increment counter
        end
    end

endmodule
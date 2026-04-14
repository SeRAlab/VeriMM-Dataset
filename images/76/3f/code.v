module top_module(
    input clk,
    input reset,
    input [3:0] init_val,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= init_val;  // Synchronous reset to initial value
        end else begin
            q <= {q[2:0], 1'b0};  // Shift left
        end
    end

endmodule
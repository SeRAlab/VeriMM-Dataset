module shift_register (
    input clk,
    input reset,
    input load,
    input [15:0] parallel_in,
    input shift_dir,  // 0 for left, 1 for right
    output reg [15:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0;  // Clear the register on reset
        end else if (load) begin
            q <= parallel_in;  // Load parallel input
        end else if (shift_dir == 1'b0) begin
            q <= {q[14:0], 1'b0};  // Shift left
        end else begin
            q <= {1'b0, q[15:1]};  // Shift right
        end
    end
endmodule
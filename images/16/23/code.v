module shift_register (
    input clk,
    input reset,
    input load,
    input shift_left,
    input shift_right,
    input [15:0] parallel_in,
    output reg [15:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0;
        end else if (load) begin
            q <= parallel_in;
        end else if (shift_left) begin
            q <= {q[14:0], 1'b0};
        end else if (shift_right) begin
            q <= {1'b0, q[15:1]};
        end
    end
endmodule
module shift_register (
    input clk,
    input reset,
    input shift_dir, // 0 for left, 1 for right
    output reg [1:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 2'b00;
        end else begin
            if (shift_dir == 0) begin
                q <= {q[0], 1'b0}; // Shift left
            end else begin
                q <= {1'b0, q[1]}; // Shift right
            end
        end
    end
endmodule
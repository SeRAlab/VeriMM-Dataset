module top_module(
    input clk,
    input reset_n,
    input shift,
    input d,
    output reg [7:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset: Reset the register to 8'b00000000
            q <= 8'b00000000;
        end else if (shift) begin
            // Shift operation: Shift left by one bit and input d
            q <= {q[6:0], d};
        end
    end

endmodule
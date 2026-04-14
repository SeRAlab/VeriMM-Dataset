module shift_left_register(
    input clk,
    input reset_n,
    input shift_left_enable,
    input data_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the register to 4'b0000
            q <= 4'b0000;
        end else if (shift_left_enable) begin
            // Shift left operation: Shift left by one bit and input data_in
            q <= {q[2:0], data_in};
        end
    end

endmodule
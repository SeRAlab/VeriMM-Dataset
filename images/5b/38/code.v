module shift_register(
    input clk,
    input reset_n,
    input shift_enable,
    input data_in,
    output reg [5:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the shift register to 6'b000000
            q <= 6'b000000;
        end else if (shift_enable) begin
            // Shift operation: Shift right by one bit and input data_in
            q <= {data_in, q[5:1]};
        end
    end

endmodule
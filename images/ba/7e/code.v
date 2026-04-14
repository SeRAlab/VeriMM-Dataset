module binary_counter_with_carry (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg carry_out
);always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
            carry_out <= 1'b0;
        end else begin
            {carry_out, q} <= q + 1;
        end
    end

endmodule
module top_module(
    input [3:0] A,
    input [1:0] SHIFT,
    output reg [3:0] OUT
);always @(*) begin
        if (SHIFT >= 0) begin
            OUT = A << SHIFT;
        end else begin
            OUT = A >> (-SHIFT);  // Fixed: Using negation instead of 'abs'
        end
    end

endmodule
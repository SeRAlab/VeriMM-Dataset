module top_module(
    input [3:0] a,
    input [3:0] b,
    input mode,
    output reg [3:0] result
);always @(*) begin
        if (mode == 1'b0) // Addition mode
            result = a + b;
        else // Subtraction mode
            result = a - b;
    end

endmodule
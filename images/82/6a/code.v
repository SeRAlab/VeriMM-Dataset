module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Q
);always @(*) begin
        if (B >= 0) begin
            Q = A << B;
        end else begin
            // Since B is positive, we'll still use it as a 4-bit value. 
            // This means we should take the absolute value by inverting it.
            Q = A >> (-B); // Using two's complement to shift correctly
        end
    end

endmodule
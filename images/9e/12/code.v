module top_module(
    input [7:0] A,
    input signed [7:0] B, // Changed B to signed to correctly handle shifts.
    output reg [7:0] result
);always @(*) begin
        if (B > 0) begin
            result = A << B; // Logical shift left
        end else if (B < 0) begin
            result = A >> -B; // Logical shift right, used -B since B is signed.
        end else begin
            result = A; // No shift
        end
    end
    
endmodule
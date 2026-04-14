module top_module(A, B, Sel, Clk, Result, Cout);input [3:0] A, B;
input Sel, Clk;
output reg [3:0] Result; // Changed to reg
output reg Cout;         // Changed to reg

reg [3:0] sum;
reg [3:0] diff;
reg carry;
reg borrow;

always @(posedge Clk) begin
    if (Sel == 0) begin
        // Addition operation
        sum = A + B;
        carry = (sum > 15) ? 1 : 0;
        Result = sum[3:0];
        Cout = carry;
    end else begin
        // Subtraction operation
        diff = A - B;
        borrow = (A < B) ? 1 : 0;
        Result = diff[3:0];
        Cout = borrow;
    end
end

endmodule
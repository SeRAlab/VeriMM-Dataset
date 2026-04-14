module top_module(
    A,
    B,
    Cin,
    Clk,
    S,
    Cout
);input [3:0] A;
    input [3:0] B;
    input Cin;
    input Clk;
    output reg [3:0] S;  // Changed to reg type
    output reg Cout;      // Changed to reg type

    wire [3:0] sum;
    wire carry;

    // Carry bits calculation
    assign sum = A + B + Cin;
    assign carry = (A[3] & B[3]) | (Cin & (A[3] ^ B[3]));

    always @(posedge Clk) begin
        S <= sum;
        Cout <= carry;      // Updated to use correct carry wire
    end

endmodule
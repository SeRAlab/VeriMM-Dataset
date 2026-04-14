module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] S,  // Changed to reg
    output reg Cout       // Changed to reg
);reg [4:0] Sum;  // Changed to 5 bits to accommodate carry

always @ (A or B or Cin)
begin
    Sum = A + B + Cin;
    S = Sum[3:0];  // Assign only the lower 4 bits to S
    Cout = Sum[4]; // Assign the carry-out
end

endmodule
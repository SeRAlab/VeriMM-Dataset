module top_module(A, B, Z, Cout);input [3:0] A, B;
output reg [3:0] Z;  // Change Z to reg type to allow assignment in always block
output reg Cout;      // Change Cout to reg type to allow assignment in always block

always @(*) begin
    {Cout, Z} = A + B;  // Concatenate the carry out and sum
end

endmodule
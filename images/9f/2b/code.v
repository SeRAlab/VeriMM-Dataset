module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] S,
    output reg Cout
);always @(*) begin
    {Cout, S} = A + B + Cin; // Concatenate Cout with S
end

endmodule
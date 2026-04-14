module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Clock,
    output [3:0] Sum,
    output Cout
);

reg [3:0] Sum;
reg Cout;

always @(posedge Clock) begin
    {Cout, Sum} = A + B + Cin;
end

endmodule
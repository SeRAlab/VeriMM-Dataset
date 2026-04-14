module binary_adder(A, B, CIN, SUM, COUT);
input [1:0] A, B;
input CIN;
output [1:0] SUM;
output COUT;
reg [1:0] SUM;
reg COUT;

always @(*) begin
    {COUT, SUM} = A + B + CIN;
end

endmodule
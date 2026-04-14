module adder_4bit(A, B, SUM, COUT);
input [3:0] A, B;
output [3:0] SUM;
output COUT;
reg [3:0] SUM;
reg COUT;

always @(A or B) begin
    {COUT, SUM} = A + B;
end

endmodule
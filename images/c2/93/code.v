module adder16(
    input [15:0] A,
    input [15:0] B,
    input CIN,
    output [15:0] SUM,
    output COUT
);

reg [15:0] sum_temp;
reg cout_temp;

always @(*) begin
    {cout_temp,sum_temp} = A + B + CIN;
end

assign SUM = sum_temp;
assign COUT = cout_temp;

endmodule
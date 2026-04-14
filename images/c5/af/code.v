module calculator(
    input [3:0] a,
    input [3:0] b,
    input op,
    output reg [3:0] out
);

always @*
begin
    if (op == 0) // addition
        out = a + b;
    else // subtraction
        out = a - b;
end

endmodule
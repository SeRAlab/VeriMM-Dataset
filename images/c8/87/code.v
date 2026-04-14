module calculator(
    input [3:0] in1,
    input [3:0] in2,
    input op,
    output reg [3:0] out
);

always @(*) begin
    if(op == 0) // addition
        out = in1 + in2;
    else // subtraction
        out = in1 - in2;
end

endmodule
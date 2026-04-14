module comparator (
    input [2:0] A,
    input [2:0] B,
    output reg out
);

always @(*) begin
    if (A > B)
        out = 1;
    else if (A < B)
        out = 0;
    else
        out = 0;
end

endmodule
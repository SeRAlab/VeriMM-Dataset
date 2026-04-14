module top_module(
    input A,
    input B,
    input S,
    output reg Y
);always @ (A, B, S)
begin
    if (S == 0)
        Y = A;
    else
        Y = B;
end

endmodule
module mux_2to1 (
    input A,
    input B,
    input S,
    output reg Y
);

always @ (A, B, S)
begin
    if (S == 0)
        Y = A;
    else
        Y = B;
end

endmodule
module mux2to1 (
    input A,
    input B,
    input SEL,
    output reg Y
);

always @ (SEL, A, B)
begin
    if (SEL == 0)
        Y <= A;
    else
        Y <= B;
end

endmodule
module mux2to1(A, B, SEL, Y);
input A, B, SEL;
output Y;
reg Y;

always @(A or B or SEL) begin
    if (SEL)
        Y <= B;
    else
        Y <= A;
end

endmodule
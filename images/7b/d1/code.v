module mux_2to1(A, B, Sel, Y);
input A, B, Sel;
output reg Y;

always @(*) begin
    if (Sel)
        Y = B;
    else
        Y = A;
end

endmodule
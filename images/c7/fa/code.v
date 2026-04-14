module mux_2to1 (
    input A,
    input B,
    input S,
    output reg Y
);

always @(A, B, S) begin
    if (S == 0) begin
        Y <= A;
    end else if (S == 1) begin
        Y <= B;
    end else begin
        Y <= 0;
    end
end

endmodule
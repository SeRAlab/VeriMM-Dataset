module twos_complement (
    input A,
    input B,
    input C,
    input D,
    output reg [3:0] out
);

    always @(*) begin
        if (A) begin
            out <= ~(B-1) & ~(C-1) & ~(D-1);
        end else begin
            out <= {A, B, C, D};
        end
    end

endmodule
module comparator (
    A,
    B,
    EQ
);

    input [1:0] A;
    input [1:0] B;
    output reg EQ;

    always @(*) begin
        if (A == B) begin
            EQ = 1;
        end else begin
            EQ = 0;
        end
    end

endmodule
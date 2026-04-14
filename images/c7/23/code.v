module U2 (
    input [7:0] A,
    input [7:0] B,
    output [7:0] OUT
);

    always @(*) begin
        OUT = (A >= B) ? (A - B) : (B - A);
    end

endmodule
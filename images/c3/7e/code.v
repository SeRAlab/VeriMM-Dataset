module logic_func_4x2 (
    input A,
    input B,
    input C,
    input D,
    output reg X,
    output reg Y
);

always @(*) begin
    X = (A & B) | (C & D);
    Y = (A & C) | (B & D);
end

endmodule
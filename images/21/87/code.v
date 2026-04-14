module comparator_32bit (
    input [31:0] A,
    input [31:0] B,
    output reg equal,
    output reg greater,
    output reg less
);

always @(*) begin
    if (A == B) begin
        equal = 1;
        greater = 0;
        less = 0;
    end else if (A > B) begin
        equal = 0;
        greater = 1;
        less = 0;
    end else begin
        equal = 0;
        greater = 0;
        less = 1;
    end
end

endmodule